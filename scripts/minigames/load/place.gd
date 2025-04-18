class_name Place
extends ItemState

func physics_update(delta: float) -> void:
	item.global_position = item.get_global_mouse_position()
	finished.emit(MOVABLE)
