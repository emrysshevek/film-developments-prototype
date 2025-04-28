extends FilmDevState

@export var max_target_slots = 5
@export var target_window = Vector2(PI, 2.0 * PI)
@export var max_rounds_per_section = 5
@export var max_sections = 3

var setup = false
var round = 1
var section = 1

var wait_for_input = false

func enter(previous_state_path: String, _data := {}) -> void:
	if round > max_rounds_per_section:
		print("finished section")
		if section >= max_sections:
			print("you win")
			wait_for_input = true
			return
		minigame.targets_per_round += 1
		minigame.seconds_per_rotation *= .9
		round = 1
		section += 1
			
	print("round: ", round, ", section: ", section)
	round += 1
			
	if not setup:
		setup_minigame()
	
	setup_targets()
	
	wait_for_input = previous_state_path != SPIN
		
func setup_minigame() -> void:
	var circle_radius: float = minigame.tracker.get_node("Sprite2D").texture.get_size().x / 2.0
	var ring_radius:  float = minigame.outer.texture.get_size().x / 2.0

	minigame.radius = ring_radius - circle_radius
	
	print(circle_radius, " ", ring_radius, " ", minigame.radius)

	minigame.tracker.global_position = minigame.outer.global_position + Vector2(0, -minigame.radius)
	setup = true
	
	
func physics_update(_delta: float) -> void:
	if not wait_for_input:
		finished.emit(SPIN)
		return
		
	if Input.is_action_just_pressed(&"interact"):
		finished.emit(SPIN)
		
func setup_targets() -> void:
	for target in minigame.get_node("Targets").get_children():
		target.queue_free()
		
	var step_size = (target_window.y - target_window.x) / (max_target_slots - 1)
	var slots = []
	for i in range(minigame.targets_per_round):
		var target = preload("res://scripts/minigames/film_dev/target.tscn").instantiate()
		target.tracker = minigame.tracker
		minigame.targets.add_child(target)
		
		var slot = randi_range(0, max_target_slots - 1)
		while slot in slots:
			slot = randi_range(0, max_target_slots - 1)
		slots.append(slot)
		var angle = target_window.y + (step_size * slot)
		target.global_position = minigame.outer.global_position + Vector2(cos(angle) * minigame.radius, sin(angle) * minigame.radius)
