class_name Darkroom extends Node3D

@export var cameras: Array[Camera3D]

var curr_camera_idx := 0

func _ready() -> void:
	cameras[curr_camera_idx].make_current()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		curr_camera_idx = (curr_camera_idx + 1) % len(cameras)
	elif Input.is_action_just_pressed("right"):
		curr_camera_idx = (curr_camera_idx - 1) % len(cameras)
		
	cameras[curr_camera_idx].make_current()
