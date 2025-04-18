class_name LockNode extends CanvasLayer

@onready var tumbler: LockButton = $Tumbler
@onready var lock_key: TextureRect = $Lock_Key
@onready var lock_bg: TextureRect = $Lock_BG


func _ready():
	lock_key.rotation = deg_to_rad(randi_range(0,350))
	tumbler.rotation = deg_to_rad(randi_range(0,350))

func _process(_delta):
	pass


func _on_tumbler_pressed():
	if (tumbler.rotation_degrees > fmod(lock_key.rotation_degrees, 360) - 10) and (tumbler.rotation_degrees < lock_key.rotation_degrees + 10):
		print("You hit the area")
		tumbler.is_locked = true
		tumbler.rotation_degrees = lock_key.rotation_degrees
		lock_bg.modulate = Color(0,1,0,.5)
	else:
		print("next time")
		print("tumbler position:", tumbler.rotation_degrees, " lock position:", lock_key.rotation_degrees)
