extends StaticBody2D

#	Copyright 2019  Dor "GodRabbit" Shlush
# This file is part of "DeliciousRebirth".
#
#    "DeliciousRebirth" is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    "DeliciousRebirth" is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with "DeliciousRebirth".  If not, see <https://www.gnu.org/licenses/>.
#
#	Copyright 2019  Dor "GodRabbit" Shlush

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