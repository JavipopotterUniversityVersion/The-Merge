class_name Inventory
extends Node

static var items = ["Sword", "Shield"]

static func remove_item(item_name):
	items.erase(item_name)

static func add_item(item_name):
	items.push_back(item_name)

static func get_random_item():
	return items[randi_range(0, items.size()-1)]
