extends StaticBody2D

# the lamp is changing through the day. at night its get lighted and touching it melts
# the player (heating_area is an area2D used for player detection)
# We can't have the player melt continously as it would kill the player instantly
# so we have a timer (heating_cooldown) that keeps track of the cooldown

const ON_STATE = "ON"
const OFF_STATE = "OFF"

var current_state = OFF_STATE

var is_on_cooldown = false

const melting_strength = 1

func _ready():
	set_physics_process(true)
	$heating_cooldown.connect("timeout", self, "on_cooldown_end")
	global_data.connect("time_of_day_changed", self, "on_time_of_day_changed")
	light_lamp()

func _physics_process(delta):
	for body in $heating_area.get_overlapping_bodies():
		if(!is_on_cooldown && current_state == ON_STATE && body.get_name() == "player"):
			body.add_mp(-melting_strength)
			$heating_cooldown.start()
			is_on_cooldown = true


func light_lamp():
	current_state = ON_STATE
	$sprite.set_texture(load("res://images/street_light_on.png"))
	$sprite/light.enabled = true

func turn_off():
	current_state = OFF_STATE
	$sprite.set_texture(load("res://images/street_light_on.png"))
	$sprite/light.enabled = false

# change lamp state
func on_time_of_day_changed():
	if(global_data.get_current_time_of_day() == global_data.night_time):
		 light_lamp()
	else:
		turn_off()

func on_cooldown_end():
	is_on_cooldown = false