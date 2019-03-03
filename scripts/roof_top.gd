extends StaticBody2D

export var house_id = 1

func _ready():
	$sprite.set_texture(load("res://images/house"+str(house_id)+".png"))
