extends Camera3D
class_name FilmCamera

signal took_photo(photo: ViewportTexture)

@export var focus_dist := 2.0
@export var focus_range := Vector2(0.1, 100.0)
@export var focus_step := .1

@export var focal_length := 35
@export var f_stop := 3.2

@onready var focus_shader: ShaderMaterial = $FocusScreen.material_override
@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var grain: ColorRect = $CanvasLayer/FilmGrain
@onready var mirror: ColorRect = $CanvasLayer/Mirror

var in_photo_mode := false

func _ready() -> void:
	focus_shader.set_shader_parameter("focal_distance", focus_dist)
	focus_shader.set_shader_parameter("focal_length", focal_length)
	(attributes as CameraAttributesPhysical).frustum_focal_length = focal_length
	focus_shader.set_shader_parameter("f_number", f_stop)
	
func _physics_process(delta: float) -> void:
		
	if in_photo_mode:
		if Input.is_action_pressed("special_1"):
			_adjust_f_stop()
		elif Input.is_action_pressed("special_2"):
			_adjust_zoom()
		else:
			_adjust_focus()
			
		if Input.is_action_just_pressed("interact"):
			take_photo()
	
	if Input.is_action_just_pressed("camera"):
		toggle_photo_mode()

func _adjust_focus() -> void:
	if Input.is_action_just_pressed("scroll_up"):
		focus_dist = clamp(focus_dist + focus_step, focus_range.x, focus_range.y)
	elif Input.is_action_just_pressed("scroll_down"):
		focus_dist = clamp(focus_dist - focus_step, focus_range.x, focus_range.y)
	focus_shader.set_shader_parameter("focal_distance", focus_dist)
	
func _adjust_zoom() -> void:
	if Input.is_action_just_pressed("scroll_up"):
		focal_length = clamp(focal_length + 1, 15, 100)
	elif Input.is_action_just_pressed("scroll_down"):
		focal_length = clamp(focal_length - 1, 15, 100)
	focus_shader.set_shader_parameter("focal_length", focal_length)
	(attributes as CameraAttributesPhysical).frustum_focal_length = focal_length
		
func _adjust_f_stop() -> void:
	if Input.is_action_just_pressed("scroll_up"):
		f_stop = clamp(f_stop * sqrt(2.0), 2.0, 64.0)
	elif Input.is_action_just_pressed("scroll_down"):
		f_stop = clamp(f_stop / sqrt(2.0), 2.0, 64.0)
	focus_shader.set_shader_parameter("f_number", f_stop)

		
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

func toggle_photo_mode() -> void:
	in_photo_mode = not in_photo_mode
	if in_photo_mode:
		ap.play(&"raise")
	else:
		ap.play(&"lower")
