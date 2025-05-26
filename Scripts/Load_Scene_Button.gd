extends Button
@export var scene:String = ""

func _ready():
	print(ScenesManager)
	button_up.connect(func(): ScenesManager.load_scene(scene))
