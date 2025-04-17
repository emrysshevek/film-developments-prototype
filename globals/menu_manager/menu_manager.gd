extends Node

# Store both the path and the instance
var scene_stack: Array = []

#func _ready():
	#if get_tree().current_scene and get_tree().current_scene != self:
		#return
	#if default_menu_scene:
		#push_scene(default_menu_scene)

func push_scene(scene_path: String, scene:Node=null) -> Node:
	if scene == null:
		scene = load(scene_path).instantiate()
	#var new_scene: Node = scene.instantiate()

	# Remove the current top scene
	if scene_stack.size() > 0:
		var top_entry = scene_stack[scene_stack.size() - 1]
		if top_entry.scene:
			top_entry.scene.queue_free()

	add_child(scene)
	scene_stack.append({ "scene_path": scene_path, "scene": scene })
	return scene

func pop_scene():
	if scene_stack.size() > 0:
		var top_entry = scene_stack.pop_back()
		if top_entry.scene:
			top_entry.scene.queue_free()

	if scene_stack.size() > 0:
		var prev_entry = scene_stack[scene_stack.size() - 1]
		var scene = load(prev_entry.scene_path)
		var new_scene: Node = scene.instantiate()
		add_child(new_scene)
		prev_entry.scene = new_scene

func get_top_scene() -> Node:
	if scene_stack.size() > 0:
		return scene_stack[scene_stack.size() - 1].scene
	return null

func pop_all_scenes():
	while scene_stack.size() > 0:
		pop_scene()
