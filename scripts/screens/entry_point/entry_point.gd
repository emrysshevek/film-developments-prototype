extends Node

var menu_scene: String = GameManager.start_menu_scene_path

func _ready() -> void:
	MenuManager.push_scene(menu_scene)
