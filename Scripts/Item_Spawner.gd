class_name Item_Spawner
extends Node2D

var _button:Button
var _grid_master:Grid_Master
var _combat_manager:Combat_Manager

#@export var _item_type:String

var _can_spawn:bool = true
const COOL_DOWN:float = 0.0

const BOX_SIDE:int = 60

const ITEM_SCENE = preload("res://Prefabs/item.tscn")

func _start_cool_down():
	_can_spawn = false
	await get_tree().create_timer(COOL_DOWN).timeout
	_can_spawn = true

func _ready():
	_grid_master = get_tree().get_root().get_node("GameScene/Grid_Master")
	_combat_manager = get_tree().get_root().get_node("GameScene/Combat_Manager")
	_button = get_node("../Button")
	
	_button.button_up.connect(func(): 
		if(_can_spawn == true 
			&& _combat_manager.can_act() 
			&& _grid_master.get_free_adjacent_pos(get_parent().position) != null):
			var item = ITEM_SCENE.instantiate()
			item.get_node("ItemData").init(Inventory.get_random_item(), 0)
			add_child(item)
			_itemFall(item)
			
			_combat_manager.substract_action()
			
			_start_cool_down()
		)
	await get_tree().create_timer(0.05).timeout
	_grid_master.add_object(get_parent())

func _itemFall(item:Sprite2D):
	item.position = get_parent().position
	
	var target_pos = _grid_master.get_free_adjacent_pos(get_parent().position)
	_grid_master.add_object_to_pos(item, target_pos)
	
	item.get_node("Dragger")._on_grid = false
	await get_tree().create_timer(0.2).timeout
	item.get_node("Dragger")._on_grid = true
