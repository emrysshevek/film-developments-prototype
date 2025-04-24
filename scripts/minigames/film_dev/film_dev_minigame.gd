class_name FilmDevMinigame
extends Node2D

@export var seconds_per_rotation := 3.0

@onready var outer: Sprite2D = $Outer
@onready var inner: Sprite2D = $Inner
@onready var tracker: Area2D = $Tracker
@onready var targets: Node2D = $Targets

var radius: float = 0

var targets_per_round := 1
