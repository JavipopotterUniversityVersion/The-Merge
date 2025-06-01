extends Node

const SCENES_PATH = "res://Scenes/"
const AUTOLOADS_SIZE = 3
var _current_scene

var _init_funcs = []

func _ready():
	_current_scene = get_tree().get_root().get_child(AUTOLOADS_SIZE)

func load_scene(scene_name):
	var current_scenes = []
	
	for i in range(AUTOLOADS_SIZE, get_tree().get_root().get_child_count()):
		current_scenes.push_back(get_tree().get_root().get_child(i))
	
	for scene in current_scenes:
		scene.queue_free()
		
	_add_scene(scene_name)

func _add_scene(scene_name):
	var scene_path = SCENES_PATH + scene_name + ".tscn"
	var new_scene = load(scene_path)
	_current_scene = new_scene.instantiate()
	_handle_params(_current_scene)
	get_tree().get_root().add_child(_current_scene)

func add_scene(scene_name):
	var scene_path = SCENES_PATH + scene_name + ".tscn"
	var new_scene = load(scene_path)
	get_tree().get_root().add_child(new_scene.instantiate())

func get_current_scene():
	if(_current_scene == null): return get_tree().get_root().get_child(AUTOLOADS_SIZE)
	return _current_scene

func _handle_params(scene):
	for init_func in _init_funcs: init_func.call(scene)
	_init_funcs = []

func push_init_func(init_func):
	_init_funcs.push_back(init_func)
