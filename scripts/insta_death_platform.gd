extends Area2D

export var is_disabled = false

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if(is_disabled):
		return
	if(body.get_name() == "player"):
		body.kill_player()