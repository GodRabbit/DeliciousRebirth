extends CanvasLayer

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

var path

func _ready():
	pass

func fade_to_main_manu():
	path = "res://scenes/gui/main_manu.tscn"
	$anim.play("fade_to")

func fade_to_game():
	path = "res://scenes/main_scene.tscn"
	$anim.play("fade_to")

func fade_to_tutorial():
	path = "res://scenes/gui/tutorial.tscn"
	$anim.play("fade_to")

# private function called from within the animation
func _change_scene():
	if(path != ""):
		get_tree().change_scene(path)
		get_tree().set_pause(false)