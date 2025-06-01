class_name Item

var type = ""
var level = 0
var is_shop_item = false

static func i(type, level = 0, shop = false):
	return {
		"type": type,
		"level": level,
		"shop": shop
	}
