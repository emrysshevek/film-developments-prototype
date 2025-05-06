class_name Movable
extends ItemState

func enter(_previous_state_path: String, _data := {}) -> void:
	item.selected.connect(_on_item_selected)

func exit() -> void:
	item.selected.disconnect(_on_item_selected)

func physics_update(_delta: float) -> void:
	if item.placing == false:
		finished.emit(SELECTABLE)

func _on_item_selected(_item: GameItem) -> void:
	finished.emit(CLICK)
