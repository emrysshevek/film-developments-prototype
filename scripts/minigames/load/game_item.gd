class_name GameItem extends Area2D

signal selected(which_item: GameItem)

var placing = true
var mouse_over = false

func _process(delta: float) -> void:
	#if placing and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#print("dragging")
		#global_position = get_global_mouse_position()
	#elif Input.is_action_just_pressed("interact"):
		#selected.emit(self)
		#print("selected item")
	pass


func _on_mouse_entered() -> void:
	mouse_over = true
	print("mouse entered")


func _on_mouse_exited() -> void:
	mouse_over = false
	print("mouse exited")
