class_name Inventory
extends Node

static var items = ["Sword", "Shield"]

static func remove_item(item_name):
	items.erase(item_name)

static func add_item(item_name):
	items.push_back(item_name)


static var rooms = ["Battle"]
#static var rooms = ["Battle, Shop, Question"]

static func add_room(room_name):
	rooms.push_back(room_name)

static func remove_room(room_name):
	rooms.erase(room_name)

static func get_random_item(data_route):
	if(data_route == "items"): return items[randi_range(0, items.size()-1)]
	else: if(data_route == "rooms"):  return rooms[randi_range(0, rooms.size()-1)]
	else: print("ERROR, INEXISTENT ROUTE FOR IVENTORY")

static var saved_grid_data = []
