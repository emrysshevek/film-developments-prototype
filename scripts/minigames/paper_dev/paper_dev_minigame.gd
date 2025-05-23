extends Node2D
class_name PaperDevMinigame

@export var development_time := 20.0
@export var wave_travel_time := 2.0
@export var tilt_duration := .75

var tilt := 0.0
var wave_pos := 0.0
var distortion := 0.0
var max_distortion := 25.0

@onready var tray_shader_mat: ShaderMaterial = $CanvasLayer2/TrayShader.material
@onready var print: Print = $Print
@onready var tween: Tween

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"interact"):
		rock_tray()
		print.develop(development_time)
		

func _process(_delta: float) -> void:
	#print(tilt, " ", wave_pos, " ", distortion)
	update_tray()
	
func update_tray() -> void:
	tray_shader_mat.set_shader_parameter("tilt", tilt)
	tray_shader_mat.set_shader_parameter("wave_pos", wave_pos)
	tray_shader_mat.set_shader_parameter("distortion", distortion)
	
func rock_tray() -> void:
	print("Rocking tray")
	if tween != null:
		tween.kill()
	
	tilt = 0.0
	tween = create_tween()
	
	tween.set_parallel(true)
	tween.tween_property(self, ^"distortion", 0.0, tilt_duration / 2)
	var tilt_up = tween.tween_property(self, ^"tilt", 1.0, tilt_duration / 2)
	tilt_up.set_trans(Tween.TRANS_QUINT)
	tilt_up.set_ease(Tween.EASE_IN_OUT)
	
	tween.set_parallel(false)
	var tilt_down = tween.tween_property(self, ^"tilt", 0.0, tilt_duration / 2)
	tilt_down.set_trans(Tween.TRANS_QUINT)
	tilt_down.set_ease(Tween.EASE_IN_OUT)
	
	wave_pos = .84
	tween.set_parallel(true)
	for i in range(8):
		var delay = i * wave_travel_time
		tween.tween_property(self, ^"wave_pos", .1 if i % 2 == 0 else .9, wave_travel_time).set_delay(delay)
		tween.tween_property(self, ^"distortion", max_distortion * pow(.5, i), wave_travel_time).set_delay(delay)
