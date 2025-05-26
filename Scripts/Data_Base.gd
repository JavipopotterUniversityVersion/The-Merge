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

static func set_enemy_parameters(brain:Entity_Brain, health:Health_Handler):
	var enemy = enemies[enemies.keys()[randi_range(0, enemies.size()-1)]]
	
	health.set_max_health(enemy["health"])
	brain.actions = []
	
	for action in enemy["actions"]:
		brain.actions.push_back(abilities[action])

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
		"actions": ["attack", "shield"]
	}
}
