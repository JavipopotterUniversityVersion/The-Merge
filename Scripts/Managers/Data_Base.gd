class_name Data_Base
extends Node

static var items = {
	"weapon" : ["Sword", "Shield", "Poison"],
	"room" : ["Battle", "Shop"],
}

static func get_item_type(item_name):
	for item_key in items.keys():
		if(items[item_key].has(item_name)):
			return item_key

static func set_item_parameters(item:Item_Data):
	if(match_shop(item) == false && match_room(item) == false):
		match_item(item)

static func match_item(item:Item_Data):
	match item._type:
		'Sword': Sword.create(item)
		'Shield': Shield.create(item)
		'Poison': Poison.create(item)
		

static func match_shop(item:Item_Data):
	if(item._shop == false): return false
	
	item.allie_is_target = true
	item.action = func(entity):
		var pos = item._player.global_position
		item.get_parent().show()
		
		await TweensData.get_tween("arc_go_to").call({
			"object" : item.get_parent(), 
			"duration" : 0.2,
			"pos" : pos,
			"call_back" : func(): 
				Inventory.add_item(Item.i(item._type, item._level))
		})
		
	return true

static func match_room(item:Item_Data):
	item.allie_is_target = true
	var building = ScenesManager.get_current_scene().get_node("building")
	var path = "res://Sprites/" + item._type + "/" + str(item._type) + "_" + str(item._level) + ".png"
	var texture = load(path)
	
	if(building == null): return false
	var scene_type
	
	match item._type:
		'Battle': scene_type = "GameScene"
		'Boss_Building': 
			scene_type = "GameScene"
			ScenesManager.push_init_func(func(scene):
				scene.get_node("Combat_Manager").set_set_type("bosses"))
		'Question': pass
		'Shop': scene_type = "ShopScene"
			
	item.action = func(entity):
		building.set_texture(texture)
		var player = item._player
		var pos = building.global_position
		var level = item._level
		
		await TweensData.get_tween("go_to").call({
			"object" : player, 
			"duration" : 1.2,
			"pos" : pos,
			"call_back" : func(): 
				ScenesManager.push_init_func(func(scene):
					scene.set_meta("level", level))
				ScenesManager.load_scene(scene_type),
		})
	return true

static func set_enemy_parameters(enemies_instances, type, level):
	if(level == -1): return
	var set = sets[type][level][randi_range(0, sets[type][level].size()-1)]
	
	for i in range(0, set.size()-1):
		var enemy_data = enemies[set[i]]
		var enemy_instance:Health_Handler = enemies_instances[i]
		var brain:Entity_Brain = enemy_instance.get_node("Entity_Brain");
		
		enemy_instance.set_meta("damage", enemy_data["damage"])
		enemy_instance.set_meta("shield", enemy_data["shield"])
		
		enemy_instance.texture = load("res://Sprites/Enemies/" + enemy_data["sprite"] + ".png")
		enemy_instance.set_max_health(enemy_data["health"])
		brain.actions = []
		
		for action in enemy_data["actions"]:
			brain.actions.push_back(abilities[action])
			
		enemy_instance.show()

static var abilities = {
	"attack" : 
		func(this:Health_Handler, other:Health_Handler):
			TweensData.get_tween("attack_left").call({
				"object" : this, 
				"duration" : 0.2,
				"call_back" : func(): 
					other.get_damage(this.get_meta("damage"))
					this.emit_signal("on_attack")})
			await this.get_tree().create_timer(0.2).timeout,
			
	"shield" : 
		func(this:Health_Handler, other:Health_Handler):
			this.add_shield(this.get_meta("shield"))
			await this.get_tree().create_timer(0.2).timeout,
}

static var enemies = {
	"DebugMan": {
		"health": 1,
		"damage": 0,
		"shield": 0,
		"actions": ["attack"],
		"sprite" : "Foe"
	},
	
	"John" : {
		"health": 20,
		"damage": 1,
		"shield": 4,
		"actions": ["attack", "shield"],
		"sprite" : "Foe"
	},
	
	"Mario" : {
		"health": 10,
		"damage": 2,
		"shield": 8,
		"actions": ["attack", "attack", "shield"],
		"sprite" : "Demon"
	},
	
	"Merchant" : {
		"health": 10,
		"damage": 2,
		"shield": 8,
		"actions": ["attack"],
		"sprite" : "Demon"
	}
}

static var sets = {
	"enemies" : [
#		[["DebugMan"]],
		[
			["John", "John"],
			["Mario", "John"]
		],
		[
			["John", "John", "John"],
			["John", "John", "Mario"]
		],
		[
			["John", "John", "John", "John"],
			["Mario", "Mario", "Mario"]
		],
	],
	"bosses" : [
		
	],
	"merchants": [
		[
			["Merchant"]
		],
		[
			["Merchant"]
		],
	]
}
