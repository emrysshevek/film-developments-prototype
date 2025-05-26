extends Sprite2D
class_name Print

var developing := false
@export var developed := false

@export var fade := 0.0
@export var strength := 0.0

var tween: Tween
	
func _process(_delta: float) -> void:
	material.set_shader_parameter("fade", fade)
	material.set_shader_parameter("strength", strength)
	
func _reset() -> void:
	if tween:
		tween.kill()
		
	developing = false
	developed = false
	fade = 0
	strength = 0
		
func develop(time:=20.0) -> void:
	if not developed and not developing:
		developing = true
		fade = 0.0
		strength = 0.0
		tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(self, ^"fade", 1.0, time)
		var strength_tween = tween.tween_property(self, ^"strength", 1.0, time)
		strength_tween.set_trans(Tween.TRANS_CUBIC)
		strength_tween.set_ease(Tween.EASE_IN_OUT)
		tween.finished.connect(_on_finished_development)
	
func _on_finished_development() -> void:
	developed = true
	developing = false
