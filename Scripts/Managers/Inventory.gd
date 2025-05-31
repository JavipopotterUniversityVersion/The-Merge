class_name Inventory
extends Node

static var items = ["Sword", "Shield"]

static func remove_item(item_name):
	items.erase(item_name)

static func add_item(item_name):
	items.push_back(item_name)


static var rooms = ["Battle_0"]
#static var rooms = ["Battle, Shop, Question"]

static func add_room(room_name):
	rooms.push_back(room_name)

static func remove_room(room_name):
	rooms.erase(room_name)

static func get_random_item(data_route):
	var type:String
	var level:int = 0
	
	var item:String
	
	if(data_route == "items"): item = items[randi_range(0, items.size()-1)]
	else: if(data_route == "rooms"):  item = rooms[randi_range(0, rooms.size()-1)]
	else: print("ERROR, INEXISTENT ROUTE FOR IVENTORY")
	
	var item_data = item.split("_")
	type = item_data[0]
	
	if(item_data.size() > 1):
		level = int(item_data[1])
	
	return {
		"type": type,
		"level": level
	}

static var saved_grid_data = []
