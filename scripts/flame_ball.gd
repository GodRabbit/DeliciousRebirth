extends Area2D

const melting_strength = 3

var is_on_cooldown = false

func _ready():
	set_physics_process(true)
	$heating_cooldown.connect("timeout", self, "on_cooldown_end")

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if(!is_on_cooldown && body.get_name() == "player"):
			body.add_mp(-melting_strength)
			$heating_cooldown.start()
			is_on_cooldown = true

func on_cooldown_end():
	is_on_cooldown = false