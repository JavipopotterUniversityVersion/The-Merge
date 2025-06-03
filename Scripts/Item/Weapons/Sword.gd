class_name Sword extends Item_Data
var damage:int
#
#static func create(level:int) -> Sword:
#	var instance = Sword.new()
#	damage = round(pow(2.5, level+1))
#	return instance
#
#func action(entity):
#	var player = item._player
#
#	await TweensData.get_tween("attack_right").call({
#		"object" : player, 
#		"duration" : 0.2,
#		"call_back" : func(): 
#			entity.get_damage(item.p.damage)
#			player.emit_signal("on_attack"),
#	})
