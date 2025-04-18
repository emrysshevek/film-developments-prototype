class_name Movable
extends ItemState

func physics_update(_delta: float) -> void:
	if item.mouse_over and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		finished.emit(CLICK)
