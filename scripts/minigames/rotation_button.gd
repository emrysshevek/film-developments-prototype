class_name LockButton extends TextureButton

# Number of seconds for one full rotation (2π radians)
@export var seconds_per_rotation: float = 1.0
var is_locked = false

func _process(delta):
    if is_locked == false:
        var rotation_speed = TAU / seconds_per_rotation
        rotation += rotation_speed * delta
        if rotation >= TAU:
            rotation -= TAU