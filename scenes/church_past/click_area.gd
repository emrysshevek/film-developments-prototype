extends ColorRect
class_name ClickArea

signal clicked()

var default = preload("res://assets/sprites/mouse_default.png")
var enter = preload("res://assets/sprites/mouse_enter.png")
var interact = preload("res://assets/sprites/mouse_interact.png")
var next = preload("res://assets/sprites/mouse_next.png")

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		print("here")
		clicked.emit()


func _on_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(enter)


func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(default)
