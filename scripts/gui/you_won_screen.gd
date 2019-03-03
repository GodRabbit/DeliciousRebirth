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

func _ready():
	pass

func reset_kitties():
	for i in range(1, 4):
		get_node("main/golden_kitty_container/kitty"+str(i)).hide()
	

func update_gui():
	$main/time_label.set_text(global_data.get_time_string())
	$main/deaths_label.set_text(str(global_data.get_deaths()))
	
	reset_kitties()
	for i in range(0, int(min(3, global_data.get_golden_kitties()))): # global_data.get_golden_kitties()
		get_node("main/golden_kitty_container/kitty"+str(i+1)).show()

func hide():
	$main.hide()

func show():
	$main.show()