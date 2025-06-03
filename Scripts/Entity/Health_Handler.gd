class_name Health_Handler
extends Sprite2D

var _health:int = 10
@export var _max_health:int = 10
@export var is_allie:bool = false;

var _shield:int = 0

var _altered_states = {}

signal on_heal
signal on_add_shield

signal on_attack

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
	emit_signal("on_death", self)

func _process_shield(dmg:int):
	
	if(_shield > 0):
		_shield -= dmg
		_shield -= dmg
		if(_shield < 0): _shield = 0
		
	emit_signal("on_shield_damage", dmg)
	return dmg - _shield

func _reset_shield():
	_shield = 0
	emit_signal("on_shield_damage", 0)

func turn_start():
	var states_to_remove = []
	
	for state in _altered_states.values():
		await state["start"].call()
		
		if(state.power <= 0):
			state["exit"].call()
			states_to_remove.push_back(state)
	
	for state in states_to_remove:
		_altered_states.erase(state)

func turn_end():
	pass
#	for state in _altered_states:
#		await state["end"].call()

func add_altered_state(state, power):
	if(_altered_states.has(state)): 
		_altered_states[state].power + power;
	else:
		var a_altered_state = Altered_States.get_altered_state(state, self)
		a_altered_state.power = power
		_altered_states[state] = a_altered_state
		a_altered_state["set"].call()
