extends Node2D

@onready var door


@onready var curr_scene: Node2D = $Outside

func _ready() -> void:
	Dialogic.start("church_present_timeline")

func _on_door_area_interacted() -> void:
	curr_scene.hide()
	curr_scene = $Inside
	curr_scene.show()
	Dialogic.start("church_present_timeline", "Inside")


func _on_wall_area_interacted() -> void:
	Dialogic.start("church_present_timeline", "Wall")
