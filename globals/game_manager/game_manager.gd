extends Node

var save_data: SaveData

var mouse_captured: bool = false

var main_menu_scene_path: String = "uid://xh3y2hg08tav"
var start_menu_scene_path: String = "uid://xh3y2hg08tav"
var in_game_scene_path: String = "uid://cym2vheag6wb4"

func _ready():
	save_data = SaveData.load_game()

func save_game():
	save_data.save_game()
