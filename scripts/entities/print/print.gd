extends Control
class_name Print

@export var negative: Texture2D

@onready var image: TextureRect = $PaperArea/ImageArea
@onready var dev_fader: ShaderMaterial = $PaperArea/DevFadeShader.material

func _ready() -> void:
	image.texture = negative
	
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed(&"interact")):
		create_tween().tween_method(set_developer, 0.0, 1.0, 10)

func set_developer(val: float) -> void:
	dev_fader.set_shader_parameter("fade", val)
	
