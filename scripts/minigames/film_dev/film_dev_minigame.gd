class_name FilmDevMinigame
extends Node2D

@export var rps := .25

@onready var ring: Sprite2D = $Ring
@onready var dot: Sprite2D = $Dot
@onready var tank: Sprite2D = $Tank

var tween: Tween

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		agitate()
	
	dot.rotation_degrees += 360 * rps * delta
	
	
func agitate() -> void:
	print("here")
	if tween and tween.is_running():
		return
		
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(tank, "rotation_degrees", 180.0, 1.0)
	tween.tween_property(tank, "rotation_degrees", 0.0, 1.0)
