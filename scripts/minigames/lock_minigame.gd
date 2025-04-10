class_name LockMiniGame extends CanvasLayer

@export var locks_in_game: int = 3
var lock_node_scene = preload("res://scripts/minigames/lock.tscn")
var lock_nodes: Array = []
var minigame_completed = false

func _ready():
	if locks_in_game > 6:
		locks_in_game = 6
		
	for i in range(locks_in_game):
		var lock_instance = lock_node_scene.instantiate()
		$Window.add_child(lock_instance)
		if i < 3:
			lock_instance.offset = Vector2i(i * 350, 0)
		elif i < 6:
			lock_instance.offset = Vector2i((i-3) * 350, 350)
		lock_nodes.append(lock_instance)

func _process(_delta):
	get_tree().paused = true
		
	if all_locks_locked():
		minigame_completed = true

func all_locks_locked() -> bool:
	for lock_instance in lock_nodes:
		if not lock_instance.tumbler.is_locked:
			return false
	return true
