extends Button

func _ready():
	var level =  ScenesManager.get_current_scene().get_meta("level") + 1
	var defeated_enemies = ScenesManager.get_current_scene().get_node("Combat_Manager").defeated_enemies
	
	var money_to_get:int = 0
	for enemy in defeated_enemies: money_to_get += enemy.max_health
	money_to_get *= level
	text = str(money_to_get) + "$"
	
	button_up.connect(func():
		Inventory.add_money(money_to_get)
		hide())
