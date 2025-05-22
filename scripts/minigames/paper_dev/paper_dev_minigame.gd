extends Node2D
class_name PaperDevMinigame

@onready var tray: Tray = $CanvasLayer/Tray

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"interact"):
		tray.rock_tray()
		

	
	
