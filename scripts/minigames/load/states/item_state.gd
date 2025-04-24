class_name ItemState
extends State

const MOVABLE = "Movable"
const SELECTABLE = "Selectable"
const CLICK = "Click"
const DRAG = "Drag"
const PLACE = "Place"

var item: GameItem

func _ready():
	await owner.ready
	item = owner
