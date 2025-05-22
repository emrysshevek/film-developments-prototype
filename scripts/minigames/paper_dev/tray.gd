extends Control
class_name Tray

@export var wave_travel_time := 2.0

var tilt := 0.0
var wave_pos := 0.0
var distortion := 0.0
var max_distortion := 25.0

@onready var tray_shader_mat: ShaderMaterial = $TrayShader.material
@onready var tween: Tween

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
	tween.tween_property(self, ^"distortion", 0.0, .4)
	var tilt_up = tween.tween_property(self, ^"tilt", 1.0, .4)
	tilt_up.set_trans(Tween.TRANS_QUINT)
	tilt_up.set_ease(Tween.EASE_IN_OUT)
	
	tween.set_parallel(false)
	var tilt_down = tween.tween_property(self, ^"tilt", 0.0, .4)
	tilt_down.set_trans(Tween.TRANS_QUINT)
	tilt_down.set_ease(Tween.EASE_IN_OUT)
	
	wave_pos = .84
	tween.set_parallel(true)
	for i in range(8):
		var delay = i * wave_travel_time
		tween.tween_property(self, ^"wave_pos", .14 if i % 2 == 0 else .85, wave_travel_time).set_delay(delay)
		tween.tween_property(self, ^"distortion", max_distortion * pow(.5, i), wave_travel_time).set_delay(delay)
