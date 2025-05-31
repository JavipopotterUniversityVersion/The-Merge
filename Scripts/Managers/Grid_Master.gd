class_name Grid_Master
extends Node2D

@export var _rows:int = 5
@export var _columns:int = 11
const GRID_SIZE:int = 60
const GRID_SQUARE_SCENE = preload("res://Prefabs/grid_square.tscn")
const ITEM_SCENE = preload("res://Prefabs/item.tscn")
var _combat_manager:Combat_Manager
var grid_origin

@export var _load_saved:bool = false

const ADJACENT_POSITIONS = [
	Vector2i(0, 1),    # Abajo
	Vector2i(1, 0),    # Derecha
	Vector2i(0, -1),   # Arriba
	Vector2i(-1, 0),   # Izquierda
	Vector2i(1, 1),    # Abajo derecha
	Vector2i(1, -1),   # Arriba derecha
	Vector2i(-1, -1),  # Arriba izquierda
	Vector2i(-1, 1)    # Abajo izquierda
]

var _matrix = []
var _squares_matrix = []
var on_matrix_add:Signal;

func _add_to_matrix(x, y, obj):
	_matrix[x][y] = obj
	_squares_matrix[x][y].modulate = Color(1, 0.5, 0.5, 1)

func _remove_from_matrix_w(pos):
	pos = world_to_grid(pos)
	_remove_from_matrix(pos.x, pos.y)

func _remove_from_matrix(x, y):
	_matrix[x][y] = null
	_squares_matrix[x][y].modulate = Color(1, 1, 1, 1)

func _ready():
	grid_origin = global_position
	_combat_manager = get_node('../Combat_Manager')
	for x in range(0, _columns):
		var _column = []
		_column.resize(_rows)
		_column.fill(null)
		_matrix.append(_column)
		_squares_matrix.append(_column.duplicate())
		
		for y in range(0, _rows):
			var square = GRID_SQUARE_SCENE.instantiate()
			add_child(square)
			square.global_position = grid_to_world(Vector2(x,y))
			_squares_matrix[x][y] = square
	
	if(_load_saved == true): _load_saved_grid()

func grid_to_world(pos):
	return grid_origin + pos * GRID_SIZE

func world_to_grid(pos: Vector2):
	var local = pos - grid_origin
	return _clamp_pos(Vector2i(round(local.x / GRID_SIZE), round(local.y / GRID_SIZE)))

func _get_grid_elem(pos):
	if(pos.x < 0 || pos.x >= _columns || pos.y < 0 || pos.x >= _rows): return null
	return _matrix[pos.x][pos.y]

func get_free_adjacent_pos(center:Vector2):
	var real_center = world_to_grid(center)
	var pos_to_check:Vector2 = real_center
	var i = 0;
	while (_matrix[pos_to_check.x][pos_to_check.y] != null && i < ADJACENT_POSITIONS.size()):
		pos_to_check = real_center + ADJACENT_POSITIONS[i]
		pos_to_check = _clamp_pos(pos_to_check)
		i += 1
	if(_matrix[pos_to_check.x][pos_to_check.y] == null): return grid_to_world(pos_to_check)
	else: return null

func add_object(object:Sprite2D):
	var pos:Vector2 = world_to_grid(object.global_position)
	var other = _matrix[pos.x][pos.y]
	
	if(other != null):
		if(other.get_node("ItemData").try_merge(object)): return true
		else: return false
	
	add_object_to_pos(object, object.global_position)
	return true

func add_object_to_pos(object:Sprite2D, pos):
	var object_pos = object.global_position
	object.get_parent().remove_child(object)
	add_child(object)
	object.global_position = object_pos
	
	var tween:Tween = create_tween()
	var grid_pos:Vector2 = world_to_grid(pos)
	var world_fixed_pos = grid_to_world(grid_pos)
	
	tween.tween_property(object, 'global_position', world_fixed_pos, 0.2)
	_add_to_matrix(grid_pos.x, grid_pos.y, object)

func _clamp_pos(pos):
	pos.x = clamp(pos.x, 0, _columns - 1)
	pos.y = clamp(pos.y, 0, _rows - 1)
	return pos

func _exit_tree():
	if(_load_saved): _save_grid()

func _save_grid():
	var i = 0
	var j = 0
	for row in _matrix:
		for elem in row:
			if(elem == null): continue
			var item_data:Item_Data = elem.get_node("ItemData")
			if(item_data.saveable):
				Inventory.saved_grid_data.push_back({
					"type": item_data._type,
					"level": item_data._level,
					"pos": elem.global_position
					})
			j += 1
		i += 1

func _load_saved_grid():
	var saved_grid = Inventory.saved_grid_data
	for item_data in saved_grid:
		var obj = ITEM_SCENE.instantiate()
		obj.get_node("ItemData").init(item_data.type, item_data.level)
		add_child(obj)
		obj.global_position = item_data.pos
		add_object(obj)
	Inventory.saved_grid_data = []
