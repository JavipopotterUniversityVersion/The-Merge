class_name Poison

static func create(item:Item_Data):
	item.allie_is_target = false
	set_parameters(item)
	
	item.action = func(entity):
		entity.add_altered_state("Poison", item.p.poison)

static func set_parameters(item:Item_Data):
	var poison = round(pow(2.25, item._level))
	item.p.poison = poison
