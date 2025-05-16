extends Camera3D

@export var focus_dist := 1.0
@export var focus_range := Vector2(0.01, 1000.0)
@export var focus_step := .1

@onready var focus_shader: ShaderMaterial = $FocusScreen.material_override

func _ready() -> void:
	focus_shader.set_shader_parameter("u", focus_dist)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					
				focus_dist = clamp(focus_dist + focus_step, focus_range.x, focus_range.y)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				focus_dist = clamp(focus_dist - focus_step, focus_range.x, focus_range.y)
			print("updated focus dist: ", focus_dist)
			focus_shader.set_shader_parameter("u", focus_dist)
