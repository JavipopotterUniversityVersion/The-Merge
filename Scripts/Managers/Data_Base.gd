class_name Data_Base
extends Node

static var items = [
	"Sword",
	"Shield",
	"Poison"
]

static func set_item_parameters(item:Item_Data):
	if(match_room(item) == false):
		match_item(item)

static func match_item(item:Item_Data):
	match item._type:
		'Sword':
			item.allie_is_target = false
			item.action = func(entity):
				var level = item._level
				var player = item._player
				await TweensData.get_tween("attack_right").call({
					"object" : player, 
					"duration" : 0.2,
					"call_back" : func(): 
						entity.get_damage(pow(2.5, level+1))
						player.emit_signal("on_attack"),
				})
			
		'Shield':
			item.allie_is_target = true
			item.action = func(entity):
				entity.add_shield(pow(2.25, item._level+1))
		
		'Poison':
			item.allie_is_target = false
			item.action = func(entity):
				var level = item._level
				entity.add_altered_state("Poison", pow(2.25, item._level))

static func match_room(item:Item_Data):
	item.allie_is_target = true
	var building = ScenesManager.get_current_scene().get_node("building")
	var path = "res://Sprites/" + item._type + "/" + str(item._type) + "_" + str(item._level) + ".png"
	var texture = load(path)
	
	if(building == null): return false
	
	match item._type:
		'Battle':
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
						ScenesManager.set_init_func(func(scene):
							scene.get_node("Combat_Manager").set_level(level))
						ScenesManager.load_scene("GameScene"),
				})
		'Question':
			pass
		'Shop': 
			pass
			
	return true

static func set_enemy_parameters(enemies_instances, level):
	if(level == -1): return
	var set = enemies_sets[level][randi_range(0, enemies_sets[level].size()-1)]
	
	for i in range(0, set.size()):
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
	}
}

static var enemies_sets = [
	[["DebugMan"]],
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
]
