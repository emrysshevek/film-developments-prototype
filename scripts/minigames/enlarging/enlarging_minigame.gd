extends Node2D
class_name EnlargingMinigame

@export var focus_step := .2

@onready var focus_shader: ShaderMaterial = $CanvasLayer3/Focus.material
@onready var focus = randf_range(-3, 3)

func _ready() -> void:
	focus_shader.set_shader_parameter("focus", focus)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(&"scroll_up"):
		focus = min(focus + focus_step, 6)
		focus_shader.set_shader_parameter("focus", focus)
	elif Input.is_action_just_pressed(&"scroll_down"):
		focus = max(focus - focus_step, -6)
		focus_shader.set_shader_parameter("focus", focus)
		
