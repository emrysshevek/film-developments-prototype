class_name Place
extends ItemState

var offset: Vector2 = Vector2.ZERO

func enter(_previous_state_path: String, _data := {}) -> void:
	offset = _data.offset

func physics_update(delta: float) -> void:
	item.global_position = item.get_global_mouse_position() + offset
	finished.emit(MOVABLE)
