extends Node
class_name Altered_States

static func get_altered_state(state, entity:Health_Handler):
	var altered_state = {}
	
	match state:
		'Poison':
			altered_state.set = func():
				pass
				
			altered_state.start = func():
				entity.get_damage(altered_state.power)
				altered_state.power -= 1
				await entity.get_tree().create_timer(1).timeout
			
			altered_state.exit = func():
				pass
		
		'Fire':
			altered_state.set = func():
				entity.on_attack.connect(func():
					entity.get_damage(altered_state.power))
			
			altered_state.start = func():
				pass
				
			altered_state.exit = func():
				pass
	
	return altered_state
