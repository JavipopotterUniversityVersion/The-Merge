class_name Entity_Brain
extends Node

var _target:Health_Handler
var actions = []
var _current_action = 0

func _ready():
	_target = get_parent().get_node("../Player")

func act():
	await actions[_current_action].call(get_parent(), _target)
	_current_action += 1
	if(_current_action >= len(actions)): _current_action = 0
