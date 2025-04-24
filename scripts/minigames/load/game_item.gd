class_name GameItem extends Area2D

signal selected(which_item: GameItem)

var placing := true
var mouse_over := false
var timestamp := 0


func select(count: int) -> void:
	selected.emit(self)
	z_index = count

func _on_mouse_entered() -> void:
	mouse_over = true
	print("mouse entered")


func _on_mouse_exited() -> void:
	mouse_over = false
	print("mouse exited")
