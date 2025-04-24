extends Node2D

@export var film: GameItem
@export var opener: GameItem
@export var scissors: GameItem
@export var reel: GameItem
@export var tank: GameItem
@export var lid: GameItem

var state = "placing"
var current_item: GameItem = null

@onready var items: Array[GameItem] = [film, opener, scissors, reel, tank, lid]

func _on_lights_out() -> void:
	state = "selecting"
	for item: GameItem in $Items.get_children():
		item.placing = false
		item.selected.connect(_on_item_selected)
	$CanvasLayer/ColorRect.show()
	next_item()

func _on_item_selected(item: GameItem) -> void:
	if item == current_item:
		if len(items) <= 0:
			print("You win!")
		else:
			next_item()

func next_item() -> void:
	current_item = items.pop_front()
	$CanvasLayer/TextureRect.texture = current_item.get_node("Sprite2D").texture
