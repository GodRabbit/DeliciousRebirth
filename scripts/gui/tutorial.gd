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