class_name LifeBar
extends ProgressBar

var label:Label
var _health_handler:Health_Handler
const CORNFLOWER_BLUE:Color = Color(0.392157, 0.584314, 0.929412, 1)
const RED:Color = Color(1,0,0,1)

func _ready():
	label = get_node("Label")
	_health_handler = get_parent()
	position.y = get_parent().get_rect().size.y/2
	max_value = _health_handler._max_health
	
	_health_handler.on_set_max_health.connect(func(): 
		max_value = _health_handler._max_health
		value = _health_handler._health
		_update_label()
		)
		
	_health_handler.on_get_damage.connect(func(dmg): 
		value = _health_handler._health
		_update_label())
		
	_health_handler.on_heal.connect(func(dmg): 
		value = _health_handler._health
		_update_label())
		
	var style = get_theme_stylebox("fill") as StyleBoxFlat
	
	_health_handler.on_add_shield.connect(
		func (amount): 
			style.bg_color = CORNFLOWER_BLUE)
			
	_health_handler.on_shield_damage.connect(
		func (amount): 
			if(_health_handler._shield <= 0): 
				style.bg_color = RED)

func _update_label():
	label.text = str(_health_handler.get_health()) + "/" + str(_health_handler._max_health)
