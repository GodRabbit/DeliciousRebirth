extends CanvasLayer

var path

func _ready():
	pass

func fade_to_main_manu():
	path = "res://scenes/gui/main_manu.tscn"
	$anim.play("fade_to")

func fade_to_game():
	path = "res://scenes/main_scene.tscn"
	$anim.play("fade_to")

func fade_to_tutorial():
	path = "res://scenes/gui/tutorial.tscn"
	$anim.play("fade_to")

# private function called from within the animation
func _change_scene():
	if(path != ""):
		get_tree().change_scene(path)
		get_tree().set_pause(false)