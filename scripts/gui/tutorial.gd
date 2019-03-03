extends Node2D

var current_page = 1

func _ready():
	set_process_input(true)

func _input(event):
	if(event.is_action_pressed("ui_accept") || event.is_action_pressed("ui_right") || 
	event.is_action_pressed("pause") || event.is_action_pressed("restart")):
		if(current_page == 1):
			move_to_page(2)
		elif(current_page == 2):
			global_transition.fade_to_main_manu()
	elif(event.is_action_pressed("ui_left")):
		if(current_page == 2):
			move_to_page(1)

func update_gui():
	if(current_page == 1):
		$page1.show()
		$page2.hide()
	else:
		$page2.show()
		$page1.hide()

func move_to_page(id):
	current_page = id
	update_gui()