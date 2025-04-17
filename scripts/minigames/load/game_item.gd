class_name GameItem extends ColorRect

signal selected(which_item: GameItem)

var mouse_over = false

func _process(delta: float) -> void:
	if mouse_over and Input.is_action_just_pressed("interact"):
		selected.emit(self)
		
		
func _on_mouse_entered() -> void:
	mouse_over = true


func _on_mouse_exited() -> void:
	mouse_over = false
