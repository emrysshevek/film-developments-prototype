extends FilmDevState

func enter(previous_state_path: String, _data := {}) -> void:
	var base_size: float = 100.0

	var outer_radius = (minigame.outer.scale.x * base_size) / 2.0
	minigame.radius = outer_radius - 75.0
	var inner_radius = outer_radius - 100

	minigame.inner.global_position = minigame.outer.global_position
	var inner_width = (inner_radius * 2.0)
	minigame.inner.scale = Vector2(inner_width / base_size, inner_width / base_size)

	minigame.tracker.global_position = minigame.outer.global_position + Vector2(0, -minigame.radius)
	
	setup_targets()
	
	if previous_state_path == SPIN:
		finished.emit(SPIN)

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed(&"interact"):
		finished.emit(SPIN)
		
func setup_targets() -> void:
	for target in minigame.get_node("Targets").get_children():
		target.queue_free()
	
	for i in range(minigame.targets_per_round):
		var target = preload("res://scripts/minigames/film_dev/target.tscn").instantiate()
		target.tracker = minigame.tracker
		minigame.targets.add_child(target)
		target.global_position = minigame.outer.global_position + Vector2(0, minigame.radius)
