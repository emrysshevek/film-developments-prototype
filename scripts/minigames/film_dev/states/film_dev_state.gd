class_name FilmDevState
extends State

const RESET = "Reset"
const SPIN = "Spin"
const STOP = "Stop"

var minigame: FilmDevMinigame

func _ready() -> void:
	await owner.ready
	minigame = owner as FilmDevMinigame
