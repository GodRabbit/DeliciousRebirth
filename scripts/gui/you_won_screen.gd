extends CanvasLayer



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