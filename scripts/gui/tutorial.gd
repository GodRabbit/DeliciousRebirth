extends Node2D

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

var current_page = 1

func _ready():
	set_process_input(true)

func _input(event):
	if(event.is_action_pressed("ui_accept") || event.is_action_pressed("ui_right") || 
	event.is_action_pressed("pause") || event.is_action_pressed("restart")):
		if(current_page == 1):
			move_to_page(2)
		elif(current_page == 2):
			move_to_page(3)
		elif(current_page == 3):
			global_transition.fade_to_main_manu()
	elif(event.is_action_pressed("ui_left")):
		if(current_page == 2):
			move_to_page(1)
		elif(current_page == 3):
			move_to_page(2)

func update_gui():
	if(current_page == 1):
		$page1.show()
		$page2.hide()
		$page3.hide()
	elif(current_page == 2):
		$page2.show()
		$page1.hide()
		$page3.hide()
	else:
		$page3.show()
		$page1.hide()
		$page2.hide()

func move_to_page(id):
	current_page = id
	update_gui()