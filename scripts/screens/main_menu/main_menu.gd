extends Control

func _ready():
	#MenuManager.push_scene(GameManager.start_menu_scene_path, self)
	AudioManager.c1tm_song.play()

func _on_start_button_pressed():
	AudioManager.c1tm_song.stop()
	MenuManager.push_scene(GameManager.in_game_scene_path)

func _on_options_button_pressed():
	print("Coming Soon")

func _on_quit_button_pressed():
	get_tree().quit()
