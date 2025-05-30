class_name Combat_Manager
extends Node

var _actions_label:Label
var _playerData:Health_Handler
var _enemies_data = []

var _actions_left:int = 3
var _max_actions:int = 3

@export var _level:int = 0

func _ready():
	TweensData.on_animation_start.connect(func(): get_node("End_Turn_Button").disabled = true)
	TweensData.on_animation_end.connect(func(): get_node("End_Turn_Button").disabled = false)
	
	_playerData = get_node("Entities/Player")
	_actions_label = get_node("Actions_Label")
	
	for child in get_node("Entities").get_children():
		if(child.is_allie == false): 
			_enemies_data.push_back(child)
			child.hide();
			child.on_death.connect(func():_enemies_data.erase(child))
			child.on_death.connect(_on_enemy_death)
	
	Data_Base.set_enemy_parameters(_enemies_data, _level)
	
	var hidden_enemies = []
	for enemy in _enemies_data:
		if(enemy.is_visible() == false):
			hidden_enemies.push_back(enemy)
	
	for enemy in hidden_enemies:
		_enemies_data.erase(enemy)

func _round_start():
	_playerData._reset_shield()
	_playerData.turn_start()
	
	_actions_left = _max_actions
	_actions_label.text = str(_actions_left) + "/" + str(_max_actions)
	_actions_label.modulate = Color.WHITE

func substract_action():
	_actions_left -= 1
	_actions_label.text = str(_actions_left) + "/" + str(_max_actions)
	if(_actions_left == 0): _actions_label.modulate = Color.GRAY

func can_act(): return _actions_left > 0

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
	_actions_label.hide()
	
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
	
	_actions_label.show()
	_round_start()

func _on_enemy_death():
	print("Enemies left: " +  str(_enemies_data.size()))
	if _enemies_data.size() <= 0:
		ScenesManager.add_scene("WinScene")

func set_level(level):
	_level = level
