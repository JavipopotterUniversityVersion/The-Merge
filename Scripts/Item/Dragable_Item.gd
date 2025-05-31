#bytemyke source code for https://www.youtube.com/watch?v=neZ9tLVUDk4&feature=youtu.be
extends Node2D

var _area:Area2D

var is_dragging = false #state management
var mouse_offset #center mouse on click
var delay = .2
var _can_drag:bool = false;
var _on_grid:bool = true;
var _last_pos:Vector2

var _grid_master:Grid_Master
var _combat_manager:Combat_Manager
var _item_data:Item_Data

func _ready():
	_area = get_node("../Area2D")
	_item_data = get_node("../ItemData")
	_area.mouse_entered.connect(func(): _can_drag = true)
	_area.mouse_exited.connect(func(): _can_drag = false)
	_grid_master = ScenesManager.get_current_scene().get_node("Grid_Master")
	_combat_manager =  ScenesManager.get_current_scene().get_node("Combat_Manager")
	
func _physics_process(delta):
	if is_dragging == true:
		var tween = get_tree().create_tween()
		tween.tween_property(get_parent(), "global_position", get_global_mouse_position()-mouse_offset, delay * delta)
		_combat_manager.hovering(get_parent())

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if _can_drag && _on_grid:
				is_dragging = true
				mouse_offset = get_global_mouse_position() - global_position
				_grid_master._remove_from_matrix_w(get_parent().global_position)
				_last_pos = get_parent().global_position
		else:
			if(is_dragging):
				is_dragging = false
				
				var target = _combat_manager.is_over_entity(get_parent())
				
				if(target != null):
					_item_data.trigger(target)
				else: if(_grid_master.add_object(get_parent()) == false):
					_grid_master.add_object_to_pos(get_parent(), _last_pos)
