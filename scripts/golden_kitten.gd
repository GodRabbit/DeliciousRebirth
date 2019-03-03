extends Area2D

export var is_disabled = false

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if(is_disabled):
		return
	if(body.get_name() == "player"):
		global_data.add_golden_kitten()
		is_disabled = true
		kill_kitty()

func kill_kitty():
	$anim.play("death")