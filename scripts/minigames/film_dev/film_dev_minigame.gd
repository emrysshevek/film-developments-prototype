class_name FilmDevMinigame 
extends Node2D

@onready var outer: Sprite2D = $Outer
@onready var inner: Sprite2D = $Inner
@onready var target: Area2D = $Target
@onready var tracker: Area2D = $Tracker

var seconds_per_rotation := 2.0
var radius: float = 0
var angle: float = -PI / 2.0

func _ready() -> void:
	reset()
	
func _physics_process(delta: float) -> void:
	var rps = 2.0 * PI / seconds_per_rotation
	angle += rps * delta
	tracker.global_position = outer.global_position + Vector2(cos(angle) * radius, sin(angle) * radius)
	
func reset() -> void:
	var base_size: float = 100.0
	
	var outer_radius = (outer.scale.x * base_size) / 2.0
	radius = outer_radius - 75.0
	var inner_radius = outer_radius - 100
	
	inner.global_position = outer.global_position
	var inner_width = (inner_radius * 2.0)
	inner.scale = Vector2(inner_width / base_size, inner_width / base_size)
	
	target.global_position = outer.global_position + Vector2(0, radius)
	tracker.global_position = outer.global_position + Vector2(0, -radius)
