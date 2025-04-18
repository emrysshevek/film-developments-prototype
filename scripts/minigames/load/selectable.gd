class_name Select
extends ItemState

var mouse_down = false

func physics_update(_delta: float) -> void:
	if mouse_down and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		finished.emit(CLICK)
		return

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_down = true
	else:
		mouse_down = false
