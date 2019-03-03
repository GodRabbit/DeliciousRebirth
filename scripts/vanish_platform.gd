extends StaticBody2D

# this is for a platform the vanish if it comes to contact with a player
# and reappears after a second

# if the platform is jumpable and interactable
var is_active = true

func _ready():
	$player_detector.connect("body_entered", self, "on_body_entered_player_detector")
	$vanish_timer.connect("timeout", self, "hide_platform")
	$reappear_timer.connect("timeout", self, "show_platform")

# make it inactive, and "hide" the platform
func hide_platform():
	$sprite.set_texture(load("res://images/platform_empty.png"))
	is_active = false
	$reappear_timer.start()
	$coll.disabled = true

# make platform active
func show_platform():
	$sprite.set_texture(load("res://images/platform_full.png"))
	is_active = true
	$coll.disabled = false

func on_body_entered_player_detector(body):
	if(body.get_name() == "player" && is_active):
		$vanish_timer.start()