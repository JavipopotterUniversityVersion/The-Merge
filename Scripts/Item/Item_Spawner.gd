class_name Item_Spawner
extends Node2D

var _button:Button
var _grid_master:Grid_Master
var _combat_manager:Combat_Manager

@export var _shop_spawner:bool = false
@export var data_route:String = "weapon"

var _can_spawn:bool = true
const COOL_DOWN:float = 0.0

const BOX_SIDE:int = 60

const ITEM_SCENE = preload("res://Prefabs/item.tscn")
var _level

func _start_cool_down():
	_can_spawn = false
	await get_tree().create_timer(COOL_DOWN).timeout
	_can_spawn = true

func _ready():
	_level = ScenesManager.get_current_scene().get_meta("level")
	_grid_master = ScenesManager.get_current_scene().get_node("Grid_Master")
	_combat_manager =  ScenesManager.get_current_scene().get_node("Combat_Manager")
	_button = get_node("../Button")
	
	_button.button_up.connect(func(): 
		if(_can_spawn == true 
			&& _combat_manager.can_act() 
			&& _grid_master.get_free_adjacent_pos(get_parent().position) != null):
			var item = ITEM_SCENE.instantiate()
			add_child(item)
			
			var random_item
			
			if(_shop_spawner): random_item = Shop_Manager.get_random_item(data_route, _level)
			else: random_item = Inventory.get_random_item(data_route)
			
			item.get_node("ItemData").init(random_item.type, random_item.level, random_item.shop)
			_itemFall(item)
			
			_combat_manager.handler_act()
			
			_start_cool_down()
		)
	await get_tree().create_timer(0.05).timeout
	_grid_master.add_object(get_parent())

func _itemFall(item:Sprite2D):
	var target_pos = _grid_master.get_free_adjacent_pos(get_parent().global_position)
	item.position = position
	_grid_master.add_object_to_pos(item, target_pos)
	
	item.get_node("Dragger")._on_grid = false
	await get_tree().create_timer(0.2).timeout
	item.get_node("Dragger")._on_grid = true
