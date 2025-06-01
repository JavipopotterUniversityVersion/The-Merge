extends Button
var item:String

# Called when the node enters the scene tree for the first time.
func _ready():
	var level =  ScenesManager.get_current_scene().get_meta("level")
	var item = Shop_Manager.get_random_item("weapon", level * 2)
	item.shop = false
	
	text = item.type
	icon = load("res://Sprites/" + item.type + "/" + item.type + "_" + str(item.level) + ".png")
	
	button_up.connect(func():
		Inventory.add_item(item)
		hide())
