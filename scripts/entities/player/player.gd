extends CharacterBody3D

@onready var see_cast: RayCast3D = $Head/SeeCast

@export_group("Player Stats")
@export var health: int = 100
@export var score: int = 0

@export_group("Player Movement Settings")
@export var can_move: bool = true
@export var has_gravity: bool = true
@export var can_jump: bool = true
@export var can_sprint: bool = false
@export var can_freefly: bool = false

@export_group("Speeds")
@export var look_speed: float = 0.002
@export var base_speed: float = 10.0
@export var sprint_speed: float = 14.0
@export var jump_velocity: float = 4.5
@export var freefly_speed: float = 25.0

@export_group("Input Actions")
@export var input_left: String = "left"
@export var input_right: String = "right"
@export var input_forward: String = "forward"
@export var input_back: String = "backward"
@export var input_jump: String = "ui_accept"
@export var input_sprint: String = "sprint"
@export var input_freefly: String = "freefly"

## --- Internal State ---
var look_rotation := Vector2.ZERO
var move_speed := 0.0
var freeflying := false

@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $Collider

func _ready():
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x
	_capture_mouse()
	_check_input_mappings()

func _unhandled_input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_capture_mouse()
	elif Input.is_key_pressed(KEY_ESCAPE):
		_release_mouse()

	if event is InputEventMouseMotion and not get_tree().paused:
		_rotate_look(event.relative)

	if can_freefly and Input.is_action_just_pressed(input_freefly):
		freeflying = !freeflying
		collider.disabled = freeflying
		velocity = Vector3.ZERO

func _physics_process(delta):
	if freeflying:
		_handle_freefly(delta)
		return

	if has_gravity and not is_on_floor():
		velocity += get_gravity() * delta

	if can_jump and Input.is_action_just_pressed(input_jump) and is_on_floor():
		velocity.y = jump_velocity

	move_speed = sprint_speed if can_sprint and Input.is_action_pressed(input_sprint) else base_speed

	if can_move:
		var input_dir = Input.get_vector(input_left, input_right, input_forward, input_back)
		var move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if move_dir:
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()

	if see_cast.is_colliding():
		var hit = see_cast.get_collider()
		if hit is InteractableObject:
			if Input.is_action_just_pressed("interact"):
				hit.interact()
			see_cast.debug_shape_custom_color = Color(0, 1, 0, .2) 
		else:
			see_cast.debug_shape_custom_color = Color(1, 0, 0, .2) 
	else:
		see_cast.debug_shape_custom_color = Color(0, 0, 1, .2) 

func _rotate_look(mouse_delta: Vector2):
	look_rotation.x = clamp(look_rotation.x - mouse_delta.y * look_speed, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y -= mouse_delta.x * look_speed

	transform.basis = Basis()
	rotate_y(look_rotation.y)

	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)

func _handle_freefly(delta):
	var input_dir = Input.get_vector(input_left, input_right, input_forward, input_back)
	var motion = (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	move_and_collide(motion * freefly_speed * delta)

func _capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _check_input_mappings():
	if not InputMap.has_action(input_left): _warn("input_left")
	if not InputMap.has_action(input_right): _warn("input_right")
	if not InputMap.has_action(input_forward): _warn("input_forward")
	if not InputMap.has_action(input_back): _warn("input_back")
	if can_jump and not InputMap.has_action(input_jump): can_jump = false; push_error("Jumping disabled: missing input_jump")
	if can_sprint and not InputMap.has_action(input_sprint): can_sprint = false; push_error("Sprinting disabled: missing input_sprint")
	if can_freefly and not InputMap.has_action(input_freefly): can_freefly = false; push_error("Freefly disabled: missing input_freefly")

func _warn(action: String):
	push_error("Movement disabled. No InputAction found for %s" % action)
	can_move = false
