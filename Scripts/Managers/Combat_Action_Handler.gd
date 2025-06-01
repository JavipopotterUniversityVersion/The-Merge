extends Node

var _actions_left:int = 3
var _max_actions:int = 3

var _actions_label:Label

func _ready():
	_actions_label = get_node("Actions_Label")

func can_act():
	return _actions_left > 0

func act():
	_actions_left -= 1
	_actions_label.text = str(_actions_left) + "/" + str(_max_actions)
	if(_actions_left == 0): _actions_label.modulate = Color.GRAY

func round_start():
	_actions_left = _max_actions
	_actions_label.text = str(_actions_left) + "/" + str(_max_actions)
	_actions_label.modulate = Color.WHITE
