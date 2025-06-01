class_name Inventory
extends Node

static var money:int = 20
static func add_money(amount:int): money += amount

static var items = {
	"weapon" : [Item.i("Sword")],
	"room" : [Item.i("Battle"), Item.i("Shop")],
}

static func add_item(item):
	var type = Data_Base.get_item_type(item.type)
	items[type].push_back(item)

static func get_random_item(data_route):
	var data_routes = data_route.split("_")
	var selected_route = data_routes[randi_range(0, data_routes.size()-1)]
	
	var item = items[selected_route][randi_range(0, items[selected_route].size()-1)]
	
	return item

static var saved_grid_data = []
