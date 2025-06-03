extends Node

const INFO_TEXT_SCENE = preload("res://Prefabs/info_text.tscn")
var info_text:Control

func _ready():
	info_text = INFO_TEXT_SCENE.instantiate()
	add_child(info_text)
	info_text.set_global_position(Vector2(500, 500))
	info_text.hide()

static func get_info_text(item:Item_Data):
	var info_name:String
	var info_description:String
	
	match item._type:
		'Sword':
			info_name = "Sword"
			info_description = "Deal " + item.p["damage"] + " damage"
		'Shield':
			info_name = "Shield"
			info_description = "Apply " + item.p["shield"] + " shield"
		'Poison':
			info_name = "Poison"
			info_description = "Apply " + item.p["poison"] + " poison"
		'Battle':
			info_name = "Battle"
			info_description = "Enter a battle with enemies"
		'Shop':
			info_name = "Shop"
			info_description = "A shop where you can buy items"
		'Boss_Building':
			info_name = "Boss"
			info_description = "Defeat the boss to climb up to the next floor"
	
	return {
		"title": info_name,
		"description": info_description
	}

func display_info(item:Item_Data):
	info_text.show()
	var item_info_text = get_info_text(item)
	
	info_text.get_node("Title").text = item_info_text.title
	info_text.get_node("Description").text = item_info_text.description
	
	info_text.global_position.x = item.global_position.x
	info_text.global_position.y = item.global_position.y - item.get_parent().get_rect().size.y/2

func hide_info():
	info_text.hide()
