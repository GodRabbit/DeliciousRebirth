extends Area2D

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