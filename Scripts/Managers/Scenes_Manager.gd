extends Node

const SCENES_PATH = "res://Scenes/"

func load_scene(scene_name):
	get_tree().get_root().get_child(2).queue_free()
	var scene_path = SCENES_PATH + scene_name + ".tscn"
	var new_scene = load(scene_path)
	get_tree().get_root().add_child(new_scene.instantiate())
