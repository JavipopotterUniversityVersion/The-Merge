extends Button
var item:String

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = randi_range(0, Data_Base.items.size()-1)
	var item = Data_Base.items[index]
	
	text = item
	icon = load("res://Sprites/" + item + "/" + item + "_0.png")
	
	button_up.connect(func():
		Inventory.add_item(item)
		hide())
