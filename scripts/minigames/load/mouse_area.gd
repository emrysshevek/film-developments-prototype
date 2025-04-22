extends Area2D

var counter := 1
var mouse_down := false
var selected: GameItem = null

func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()
	
	var top_item: GameItem
	for area in get_overlapping_areas():
		var item := area as GameItem
		if not top_item or item.timestamp > top_item.timestamp:
			top_item = item
			
	if top_item:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		if not mouse_down and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			top_item.select(counter)
			selected = top_item
			counter += 1
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_down = true
	else:
		mouse_down = false
		selected = null
	
