class_name PauseMenu 
extends CanvasLayer

func _ready():
	visible = false

func _on_resume_button_pressed():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameManager.mouse_captured = true

func _on_options_button_pressed():
	print("Options Coming Soon")

func _on_quit_button_pressed():
	MenuManager.push_scene(GameManager.main_menu_scene_path)
	get_tree().paused = false

func _process(_delta):
	if visible:
		get_tree().paused = true
	else: 
		get_tree().paused = false
		
