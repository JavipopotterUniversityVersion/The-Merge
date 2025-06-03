class_name Sword

static func create(item:Item_Data):
	item.allie_is_target = false
	set_parameters(item)
	
	item.action = func(entity:Health_Handler):
		var player = item._player
		
		await TweensData.get_tween("attack_right").call({
			"object" : player, 
			"duration" : 0.2,
			"call_back" : func(): 
				entity.get_damage(item.p.damage)
				player.emit_signal("on_attack")
		})

static func set_parameters(item:Item_Data):
	var damage = round(pow(2.5, item._level+1))
	item.p.damage = damage
