class_name Click
extends ItemState

var prev_state = ""

func enter(previous_state_path: String, _data := {}) -> void:
	prev_state = previous_state_path
	item.timestamp = Time.get_ticks_msec()

func physics_update(_delta: float) -> void:
	if prev_state == MOVABLE:
		finished.emit(DRAG)
	elif prev_state == SELECTABLE:
		finished.emit(SELECTABLE)
	else:
		push_error("Invalid state: ", prev_state)
