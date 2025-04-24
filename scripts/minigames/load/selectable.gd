class_name Select
extends ItemState

func enter(_previous_state_path: String, _data := {}) -> void:
	item.selected.connect(_on_item_selected)

func exit() -> void:
	item.selected.disconnect(_on_item_selected)

func _on_item_selected(item: GameItem) -> void:
	#item.selected.emit(item)
	finished.emit(CLICK)
