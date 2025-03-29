extends CanvasLayer

@onready var dev_label: Label = $DevelopedLabel

var photos_needed: int = 12
var current_chapter: String = "chapter1" 

func _process(_delta):
    var current_photos: int = GameManager.save_data.photos_developed.get(current_chapter, 0)
    dev_label.text = "Photos Developed: %d / %d" % [current_photos, photos_needed]
    if (Input.is_action_just_pressed("increase") and 
    GameManager.save_data.photos_developed[current_chapter] < GameManager.save_data.photos_required[current_chapter]) :
        GameManager.save_data.photos_developed[current_chapter] = current_photos + 1
        GameManager.save_game()
    if Input.is_action_just_pressed("reset"):
        GameManager.save_data.photos_developed[current_chapter] = 0
        GameManager.save_game()
    if Input.is_action_just_pressed("pause"):
        if $PauseMenu.visible != true:
            $PauseMenu.visible = true
        else:
            $PauseMenu.visible = false