class_name Health_Handler
extends Sprite2D

var _health:int = 10
@export var _max_health:int = 10
@export var is_allie:bool = false;

var _shield:int = 0

signal on_heal
signal on_add_shield

signal on_get_damage
signal on_shield_damage

signal on_set_max_health

signal on_death

func _ready():
	reset_health()

func reset_health():
	_health = _max_health

func set_max_health(new_health:int):
	_max_health = new_health
	_health = _max_health
	emit_signal("on_set_max_health")

func get_health(): return _health

func heal(amount:float):
	amount = round(amount)
	_health += amount
	emit_signal("on_heal", amount)

func add_shield(amount:float):
	amount = round(amount)
	_shield += amount
	emit_signal("on_add_shield", amount)
	
func get_damage(dmg:int):
	dmg = _process_shield(dmg)
	
	if(dmg > 0):
		_health -= dmg
		emit_signal("on_get_damage", dmg)
	
	if(_health <= 0):
		_health = 0
		die()
	else:
		var animation = "get_dmg_from_right" if is_allie else "get_dmg_from_left"
		TweensData.get_tween(animation).call(self)

func die():
	TweensData.get_tween("die").call(self)
	await get_tree().create_timer(2).timeout
	if is_allie: ScenesManager.load_scene("MainMenu")
	emit_signal("on_death")
	queue_free()

func _process_shield(dmg:int):
	_shield -= dmg
	
	if(_shield > 0):
		_shield -= dmg
		if(_shield < 0): _shield = 0
		emit_signal("on_shield_damage", dmg)
	
	return dmg - _shield

func _reset_shield():
	_shield = 0
	emit_signal("on_shield_damage", 0)
