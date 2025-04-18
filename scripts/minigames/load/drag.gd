class_name Drag
extends ItemState


func physics_update(delta) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		finished.emit(PLACE)
		return

	item.global_position = item.get_global_mouse_position()
