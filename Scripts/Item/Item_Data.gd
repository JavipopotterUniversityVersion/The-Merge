class_name Item_Data
extends Node2D

var _type = ""
var _level = 0
var action:Callable
var allie_is_target:bool = false
var _player:Sprite2D
var _triggers:int = 1

var free = false

func trigger(target):
	for trigger in range(0, _triggers):
		await action.call(target)
	
	if free: get_parent().queue_free()

func init(name, level):
	_type = name
	_level = level
	_update_texture()
	_update_parameters()

func _ready():
	_player = get_tree().get_root().get_node("GameScene/Combat_Manager/Entities/Player")

func _update_texture():
	if(load("res://Sprites/" + _type + "/" + _type + "_" + str(_level) + ".png")):
		get_parent().texture = load("res://Sprites/" + _type + "/" + _type + "_" + str(_level) + ".png")
		return true
	else: return false
	
func _update_parameters():
	Data_Base.set_item_parameters(self)

func _upgrade():
	_level += 1
	_update_parameters()
	return _update_texture()
	
func _compare(other): return other.get_node("ItemData")._type == _type && other.get_node("ItemData")._level == _level

func try_merge(other):
	if(_compare(other)):
		if(_upgrade() == false): return false
		other.queue_free()
		return true
	else: return false
