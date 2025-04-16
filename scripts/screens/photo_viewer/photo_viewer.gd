extends Node2D

var zoomed: bool = false
var tween: Tween

@onready var camera = $Camera2D
@onready var default_zoom = $Camera2D.zoom

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if tween:
			tween.kill()
			
		tween = create_tween()
		tween.tween_property(camera, "zoom", default_zoom if zoomed else Vector2(.8,.8), .15)
		tween.parallel().tween_property(camera, "position", Vector2.ZERO if zoomed else get_global_mouse_position(), .15)
		zoomed = !zoomed
