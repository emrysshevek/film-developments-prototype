class_name InteractableObject 
extends Area3D

func interact():
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    get_tree().paused = true
    print("You interacted with " + name + " bruh")
    pass
