extends Node2D


func _ready():
	$button_container/button_new_game.connect("pressed", self, "on_new_game_pressed")
	$button_container/button_exit.connect("pressed", self, "exit_game")
	$button_container/button_tutorial.connect("pressed", self, "start_tutorial")

func on_new_game_pressed():
	global_transition.fade_to_game()

func exit_game():
	get_tree().quit()

func start_tutorial():
	global_transition.fade_to_tutorial()