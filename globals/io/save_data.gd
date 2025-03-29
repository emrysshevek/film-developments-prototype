extends Resource
class_name SaveData

@export var display_name: String = ""

@export var photos_developed: Dictionary = {
	"chapter1": 0,
	"chapter2": 0,
	"chapter3": 0,
	"chapter4": 0,
	"chapter5": 0
}

@export var chapters_completed: Dictionary = {
	"chapter1": false,
	"chapter2": false,
	"chapter3": false,
	"chapter4": false,
	"chapter5": false
}

@export var photos_required: Dictionary = {
	"chapter1": 12,
	"chapter2": 12,
	"chapter3": 12,
	"chapter4": 9,
	"chapter5": 8
}

const SAVE_GAME_PATH: String = "user://savegame.tres"

func save_game() -> void:
	var result = ResourceSaver.save(self, SAVE_GAME_PATH)
	if result != OK:
		print("Error saving game: ", result)

static func load_game() -> SaveData:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		var resource = ResourceLoader.load(SAVE_GAME_PATH)
		if resource is SaveData:
			return resource
	return SaveData.new()