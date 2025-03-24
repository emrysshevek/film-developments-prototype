extends CharacterBody3D

@export var speed = 5.0
@export var mouse_sensitivity = 0.0015
@export var acceleration = 4.0

@onready var camera = $Camera3D

func _physics_process(delta):
	get_move_input(delta)
	move_and_slide()

func get_move_input(delta):
	var vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("left", "right", "backward", "forward")
	var dir = Vector3(-input.x, 0, input.y).rotated(Vector3.UP, rotation.y)
	velocity = lerp(velocity, dir * speed, acceleration * delta)
	velocity.y = vy
	
func _input(event):
	if event is InputEventMouseMotion:
		print("here")
		rotation.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
		camera.rotation.x -= event.relative.y * mouse_sensitivity
