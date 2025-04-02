class_name SoundButton
extends Button

@export var is_back_button: bool = false
var base_modulate: Color 

func _process(_delta):
	if is_back_button:
		if Input.is_action_just_pressed("go_back"):
			MenuManager.pop_menu()

func _on_mouse_entered():
	AudioManager.select_1_sfx.play()

func _on_pressed():
	AudioManager.confirm_1_sfx.play()
