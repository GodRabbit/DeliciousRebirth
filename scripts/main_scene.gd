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

var is_paused = false

var is_game_won = false

func _ready():
	set_process_input(true)
	$game_menu/main_node/button_container/button_restart.connect("pressed", self, "restart_scene")
	$game_menu/main_node/button_container/button_continue.connect("pressed", self, "pause_game")
	$game_menu/main_node/button_container/button_exit.connect("pressed", self, "exit_game")
	
	$you_won_screen/main/button_container/button_restart.connect("pressed", self, "restart_scene")
	$you_won_screen/main/button_container/button_exit.connect("pressed", self, "exit_game")
	
	$player.connect("game_won", self, "on_game_won")
	
	$game_menu.hide()
	$you_won_screen.hide()

func _input(event):
	if(event.is_action_released("restart")):
		restart_scene()
	elif(event.is_action_released("pause") && !is_game_won):
		pause_game()

func start_day():
	global_data.set_time_to_day()

func start_night():
	global_data.set_time_to_night()

func start_noon():
	global_data.set_time_to_noon()

# double function! when called when game is running it pauses it. while game is paused it resume
# the game to normal
func pause_game():
	if(!is_paused):
		# show pause menu
		$game_menu.show()
		is_paused = true
		
		# pause tree
		get_tree().paused = true
		
		# pause global data
		global_data.stop_timer()
	else: #unpause game
		# show pause menu
		$game_menu.hide()
		is_paused = false
		
		# pause tree
		get_tree().paused = false
		
		# pause global data
		global_data.start_timer()

func restart_scene():
	if(is_paused):
		pause_game()
	if(get_tree().paused):
		get_tree().paused = false
	global_data.reset_global_data()
	get_tree().reload_current_scene()

# exits to main menu
func exit_game():
	if(is_paused):
		pause_game()
	global_transition.fade_to_main_manu()
	global_data.reset_global_data()

func on_game_won():
	# stop global timer:
	global_data.stop_timer()
	
	# pause game:
	get_tree().paused = true
	
	# update the you won screen:
	$you_won_screen.update_gui()
	
	# show you won screen
	is_game_won = true
	$you_won_screen.show()
