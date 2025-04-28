class_name TestObject extends InteractableObject

#var lock_minigame_scene = preload("res://scripts/minigames/film_dev/lock_minigame.tscn")
var minigames: Array = []
func interact():
	super.interact()
	#var lock_minigame_instance = lock_minigame_scene.instantiate()
	#$MiniGameScreen.add_child(lock_minigame_instance)
	#minigames.append(lock_minigame_instance)

func _process(_delta):
	if all_minigames_completed():
		get_tree().paused = false
	pass

func all_minigames_completed() -> bool:
	for minigame_instance in minigames:
		if not minigame_instance.minigame_completed:
			return false
	return true
