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