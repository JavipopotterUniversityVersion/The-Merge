extends Node

signal on_animation_start
signal on_animation_end

func get_tween(tween_name):
	emit_signal("on_animation_start")
	return tweens[tween_name]

var tweens = {
	"go_to":
		func(context):
			var tween:Tween = context.object.create_tween()
			await tween.tween_property(context.object, 'position', context.pos, context.duration)
			context.call_back.call()
			emit_signal("on_animation_end"),
			
	"attack_left":
		func(context):
			var tween:Tween = context.object.create_tween()
			var init_pos = context.object.position
			tween.tween_property(context.object, 'position', init_pos + Vector2(50,0), context.duration*2/4)
			tween.tween_property(context.object, 'position', init_pos - Vector2(100,0) , context.duration/4)
			tween.tween_property(context.object, 'position', init_pos, context.duration/4)
			await context.object.get_tree().create_timer(context.duration).timeout
			context.call_back.call()
			emit_signal("on_animation_end"),
			
	"attack_right":
		func(context):
			var tween:Tween = context.object.create_tween()
			var init_pos = context.object.position
			tween.tween_property(context.object, 'position', init_pos - Vector2(50,0), context.duration*2/4)
			tween.tween_property(context.object, 'position', init_pos + Vector2(100,0) , context.duration/4)
			tween.tween_property(context.object, 'position', init_pos, context.duration/4)
			await context.object.get_tree().create_timer(context.duration).timeout
			context.call_back.call()
			emit_signal("on_animation_end"),
	
	"die":
		func(context:Sprite2D):
			var tween:Tween = context.create_tween()
			var init_pos = context.position
			tween.tween_property(context, 'rotation', 2 * PI, 0.2)
			tween.tween_property(context, 'modulate', Color(1,0,0,0), 0.3)
			emit_signal("on_animation_end"),
	
	"get_dmg_from_left":
		func(context):
			var tween:Tween = context.create_tween()
			var init_pos = context.position
			tween.tween_property(context, 'position', init_pos + Vector2(50,0), 0.1)
			tween.tween_property(context, 'position', init_pos, 0.2)
			emit_signal("on_animation_end"),
			
	"get_dmg_from_right":
		func(context):
			var tween:Tween = context.create_tween()
			var init_pos = context.position
			tween.tween_property(context, 'position', init_pos - Vector2(50,0), 0.1)
			tween.tween_property(context, 'position', init_pos, 0.2)
			emit_signal("on_animation_end"),
}
