class_name Target extends Area2D

@export var tracker: Area2D

var window_radius := 0.0
var hit = ""

@onready var good: CircleShape2D = $Good.shape
@onready var great: CircleShape2D = $Great.shape
@onready var perfect: CircleShape2D = $Perfect.shape

func _ready() -> void:
	window_radius = (tracker.get_node("Good").shape as CircleShape2D).radius + good.radius
	hit = ""

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(&"interact"):
		print(global_position.distance_to(tracker.global_position))
		if global_position.distance_to(tracker.global_position) <= window_radius:
			process_interaction()


func set_color(status) -> void:
	hit = status
	match status:
		"miss":
			modulate = Color.RED
		"good":
			modulate = Color.ORANGE
		"great":
			modulate = Color.YELLOW
		"perfect":
			modulate = Color.GREEN
			

func process_interaction() -> void:
	if hit == "" and len(get_overlapping_areas()) > 0:
		var tracker = get_overlapping_areas()[0]
		var dist = global_position.distance_to(tracker.global_position)
		if dist < perfect.radius:
			set_color("perfect")
		elif dist < great.radius:
			set_color("great")
		elif dist < good.radius:
			set_color("good")
	else:
		set_color("miss")


func _on_area_exited(area: Area2D) -> void:
	if hit == "" and area == tracker:
		set_color("miss")
		
