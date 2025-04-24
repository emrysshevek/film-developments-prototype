class_name Drag
extends ItemState

var offset: Vector2 = Vector2.ZERO

func enter(_previous_state_path: String, _data := {}) -> void:
	offset = item.global_position - item.get_global_mouse_position()

func physics_update(delta) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		finished.emit(PLACE, {"offset": offset})
		return

	item.global_position = item.get_global_mouse_position() + offset
