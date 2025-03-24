extends TextureButton
@export var link : String = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
func _on_pressed():
	AudioManager.confirm_1_sfx.play()
	AudioManager.c1tm_song.stop()
	print("This would link somewhere")
	OS.shell_open(link)

func _on_mouse_entered():
	AudioManager.select_1_sfx.play()
	
