extends Node2D
class_name Map

@onready var church: Sprite2D = $Church

var placed = false


func _physics_process(delta: float) -> void:
	if not placed and Input.is_action_just_pressed("interact"):
		print('here2')
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(church, "position", Vector2(1443.0, 278.0), .2)
		var size_tween = tween.tween_property(church, "scale", Vector2(.2, .2), .2)
		size_tween.set_ease(Tween.EASE_IN)
		size_tween.set_trans(Tween.TRANS_CUBIC)
		placed = true

func _on_area_2d_interacted() -> void:
	get_tree().change_scene_to_file("res://scenes/church_past/church_past.tscn")
