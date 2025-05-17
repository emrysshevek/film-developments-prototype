extends Camera3D
class_name FilmCamera

signal took_photo(photo: ViewportTexture)

@export var focus_dist := 2.0
@export var focus_range := Vector2(0.1, 100.0)
@export var focus_step := .1

@onready var focus_shader: ShaderMaterial = $FocusScreen.material_override
@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var grain: ColorRect = $CanvasLayer/FilmGrain
@onready var mirror: ColorRect = $CanvasLayer/Mirror

func _ready() -> void:
	focus_shader.set_shader_parameter("focal_distance", focus_dist)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				focus_dist = clamp(focus_dist + focus_step, focus_range.x, focus_range.y)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				focus_dist = clamp(focus_dist - focus_step, focus_range.x, focus_range.y)
			print("updated focus dist: ", focus_dist)
			focus_shader.set_shader_parameter("focal_distance", focus_dist)


#func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("interact"):
		#take_photo()

		
func take_photo() -> void:
	#   - hide focus circle (but not the dof blur!) and film grain
	focus_shader.set_shader_parameter("show_focus_ring", false)
	grain.hide()
	
	#   - screenshot current scene
	await RenderingServer.frame_post_draw
	var photo: ViewportTexture = get_viewport().get_texture()
	
	#   - flash black screen for duration of shutter
	mirror.show()
	create_tween()\
	.tween_property(mirror, "modulate", Color(0,0,0,0), .1)\
	.set_delay(1.0/8)\
	.finished.connect(func(): mirror.hide(); mirror.modulate = Color(0,0,0,1))
	
	#   - show focus circle and film grain
	focus_shader.set_shader_parameter("show_focus_ring", true)
	grain.show()
	
	took_photo.emit(photo)
