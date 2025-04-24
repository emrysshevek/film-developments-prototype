extends FilmDevState

var angle := 0.0
var total_targets := 0

var spinning := true

func enter(previous_state_path: String, _data := {}) -> void:
	angle = 0

func physics_update(delta: float) -> void:
	if is_equal_approx(angle, 2*PI):
		finished.emit(RESET)
		return
	#if Input.is_action_just_pressed(&"interact"):
		#spinning = not spinning
	#if not spinning:
		#return

	var rps = 2.0 * PI / minigame.seconds_per_rotation
	angle += rps * delta
	minigame.tracker.global_position = minigame.outer.global_position + Vector2(cos(angle - (PI/2.0)) * minigame.radius, sin(angle - (PI/2.0)) * minigame.radius)
	
