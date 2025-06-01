extends Node
class_name Shop_Manager

static var shop_items = {
	"weapon" : [
		Item.i("Sword",0,true),
		Item.i("Shield",0,true),
		Item.i("Poison",0,true)
	],
}

static func give_level(level):
	var tier_1_probability = float(level) / 10
	if(randf_range(0,1) < tier_1_probability): return 1
	return 0

static func get_random_item(data_route, level):
	var data_routes = data_route.split("_")
	var selected_route = data_routes[randi_range(0, data_routes.size()-1)]
	
	var item = shop_items[selected_route][randi_range(0, shop_items[selected_route].size()-1)]
	item.level = give_level(level)
	
	return item

static var saved_grid_data = []
