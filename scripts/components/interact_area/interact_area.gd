extends Area2D
class_name InteractArea

signal interacted()

enum InteractionType{
	ENTER,
	INTERACT,
	NEXT
}

@export var type: InteractionType = InteractionType.INTERACT

var default = preload("res://assets/sprites/mouse_default.png")
var enter = preload("res://assets/sprites/mouse_enter.png")
var interact = preload("res://assets/sprites/mouse_interact.png")
var next = preload("res://assets/sprites/mouse_next.png")

var mouse_over = false

func _physics_process(delta: float) -> void:
	if mouse_over and Input.is_action_just_pressed("interact"):
		interacted.emit()


func _on_mouse_entered() -> void:
	mouse_over = true
	match type:
		InteractionType.ENTER:
			Input.set_custom_mouse_cursor(enter)
		InteractionType.INTERACT:
			Input.set_custom_mouse_cursor(interact)
		InteractionType.NEXT:
			Input.set_custom_mouse_cursor(next)

func _on_mouse_exited() -> void:
	mouse_over = false
	Input.set_custom_mouse_cursor(default)
