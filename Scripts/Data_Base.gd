class_name Data_Base
extends Node

static func set_item_parameters(item:Item_Data):
	match item._type:
		'Sword':
			item.allie_is_target = false
			item.action = func(entity):
				item.get_parent().queue_free()
				var level = item._level
				TweensData.get_tween("attack_right").call({
					"object" : item._player, 
					"duration" : 0.2,
					"call_back" : func(): entity.get_damage(pow(2.5, level+1)),
				})
			
		'Shield':
			item.allie_is_target = true
			item.action = func(entity):
				item.get_parent().queue_free()
				entity.add_shield(pow(2.25, item._level+1))

static func set_enemy_parameters(enemies_instances):
	var set = enemies_sets[randi_range(0, enemies_sets.size()-1)]
	
	for i in range(0, set.size()):
		var enemy_data = enemies[set[i]]
		var enemy_instance:Health_Handler = enemies_instances[i]
		var brain:Entity_Brain = enemy_instance.get_node("Entity_Brain");
		
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
				"call_back" : func(): other.get_damage(1)
				})
			await this.get_tree().create_timer(0.2).timeout,
			
	"shield" : 
		func(this:Health_Handler, other:Health_Handler):
			this.add_shield(5)
			await this.get_tree().create_timer(0.2).timeout,
}

static var enemies = {
	"John" : {
		"health": 20,
		"actions": ["attack", "shield"],
		"sprite" : "Foe"
	},
	
	"Mario" : {
		"health": 15,
		"actions": ["attack", "attack", "shield"],
		"sprite" : "Demon"
	}
}

static var enemies_sets = [
	["John"],
	["John", "Mario"],
	["Mario", "John", "John"],
]
