extends Node

const SCENES_PATH = "res://Scenes/"
const AUTOLOADS_SIZE = 2

func load_scene(scene_name):
	var current_scenes = []
	
	for i in range(AUTOLOADS_SIZE, get_tree().get_root().get_child_count()):
		current_scenes.push_back(get_tree().get_root().get_child(i))
	
	for scene in current_scenes:
		scene.queue_free()
		
	add_scene(scene_name)

func add_scene(scene_name):
	var scene_path = SCENES_PATH + scene_name + ".tscn"
	var new_scene = load(scene_path)
	get_tree().get_root().add_child(new_scene.instantiate())
