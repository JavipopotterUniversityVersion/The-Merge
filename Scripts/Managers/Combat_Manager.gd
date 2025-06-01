class_name Combat_Manager
extends Node

var _playerData:Health_Handler
var _enemies_data = []

var _action_handler
var defeated_enemies = []

@export var _level:int = 0
@export var _set_type:String = "enemies"

func _ready():
	_level = ScenesManager.get_current_scene().get_meta("level")
	
	_action_handler = get_node("ActionHandler")
	TweensData.on_animation_start.connect(func(): get_node("End_Turn_Button").disabled = true)
	TweensData.on_animation_end.connect(func(): get_node("End_Turn_Button").disabled = false)
	_action_handler.round_start()
	
	_playerData = get_node("Entities/Player")
	
	for child in get_node("Entities").get_children():
		if(child.is_allie == false): 
			_enemies_data.push_back(child)
			child.hide();
			child.on_death.connect(_on_enemy_death)
	
	Data_Base.set_enemy_parameters(_enemies_data, _set_type, _level)
	
	var hidden_enemies = []
	for enemy in _enemies_data:
		if(enemy.is_visible() == false):
			hidden_enemies.push_back(enemy)
	
	for enemy in hidden_enemies:
		_enemies_data.erase(enemy)

func _round_start():
	_playerData._reset_shield()
	_playerData.turn_start()
	_action_handler.round_start()

func can_act(): return _action_handler.can_act()

func handler_act():
	_action_handler.act()

func is_over_entity(object):
	if(object.get_node("ItemData").allie_is_target):
		if(_playerData.global_position.y > object.global_position.y):
			_playerData.modulate = Color(1,1,1,1)
			return _playerData
	else:	
		for enemy in _enemies_data:
			if(enemy.global_position.distance_to(object.global_position) < Grid_Master.GRID_SIZE):
				enemy.modulate = Color(1,1,1,1)
				return enemy
	return null

func hovering(object):
	if(object.get_node("ItemData").allie_is_target):
		if(_playerData.global_position.y > object.global_position.y):
			_playerData.modulate = Color(0,1,0,1)
		else: _playerData.modulate = Color(1,1,1,1)
			
	else:
		for enemy in _enemies_data:
			if(enemy.global_position.distance_to(object.global_position) < Grid_Master.GRID_SIZE):
				enemy.modulate = Color(1,1,0,1)
			else: enemy.modulate = Color(1,1,1,1)


func _end_turn():
	_playerData.turn_end()
	_action_handler._actions_label.hide()
	
	await get_tree().create_timer(1).timeout
	
	for enemy in _enemies_data: 
		enemy._reset_shield()
		await enemy.turn_start()
	
	for enemy in _enemies_data:
		await enemy.get_node("Entity_Brain").act()
		await get_tree().create_timer(0.2).timeout
		
	for enemy in _enemies_data: 
		await enemy.turn_end()
		
	await get_tree().create_timer(1).timeout
	
	_action_handler._actions_label.show()
	_round_start()

func _on_enemy_death(enemy_data:Health_Handler):
	defeated_enemies.push_back({"max_health": enemy_data._max_health})
	_enemies_data.erase(enemy_data)
	print("Enemies left: " +  str(_enemies_data.size()))
	if _enemies_data.size() <= 0:
		ScenesManager.add_scene("WinScene")

func set_level(level):
	_level = level

func set_set_type(type):
	_set_type = type
