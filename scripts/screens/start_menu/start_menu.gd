extends Control

func _ready():
	AudioManager.c1ym2_song.play()

func _on_pressed():
	MenuManager.push_scene(GameManager.main_menu_scene_path)
