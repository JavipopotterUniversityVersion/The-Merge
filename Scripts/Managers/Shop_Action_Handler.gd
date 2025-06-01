extends Node

var _actions_label:Label
var _current_price = 5
var _level

func _ready():
	_actions_label = get_node("Actions_Label")
	_level = ScenesManager.get_current_scene().get_meta("level")
	_current_price = 5 + _level*2

func can_act():
	return (Inventory.money - _current_price) >= 0

func act():
	Inventory.money -= _current_price
	_current_price += _level+1
	
	_actions_label.text = "Price: " + str(_current_price) + "$\nCurrent Money: " + str(Inventory.money)
	if(Inventory.money == 0): 
		_actions_label.text = "CAN'T BUY"
		_actions_label.modulate = Color.RED

func round_start():
	_actions_label.text = "Price: " + str(_current_price) + "$\nCurrent Money: " + str(Inventory.money)
	_actions_label.modulate = Color.WHITE
