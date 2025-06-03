class_name Shield

static func create(item:Item_Data):
	item.allie_is_target = true
	set_parameters(item)
	
	item.action = func(entity):
		entity.add_shield(item.p.shield)

static func set_parameters(item:Item_Data):
	var shield = round(pow(2.25, item._level+1))
	item.p.shield = shield
