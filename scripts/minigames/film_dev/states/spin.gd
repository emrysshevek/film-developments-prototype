extends FilmDevState

var angle := 0.0
var total_targets := 0

var spinning := true

func physics_update(delta: float) -> void:
	if angle >= 2.0 * PI:
		angle -= 2.0 * PI
		finished.emit(RESET)
		return

	var rps = 2.0 * PI / minigame.seconds_per_rotation
	angle += rps * delta
	minigame.tracker.global_position = minigame.outer.global_position + Vector2(cos(angle - (PI/2.0)) * minigame.radius, sin(angle - (PI/2.0)) * minigame.radius)
	
