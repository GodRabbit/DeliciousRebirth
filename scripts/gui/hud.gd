extends CanvasLayer

# nodes:
onready var mp_progress = $mp_progress
onready var timer_label = $main_container/timer_label
onready var happy_cats_label = $main_container/happy_cats_container/happy_cats_label
onready var time_of_day_label = $time_of_day_label

var player

func _ready():
	set_process(true)
	
	global_data.connect("time_of_day_changed", self, "update_time_of_day")

func _process(delta):
	update_timer()

func set_player(p):
	player = p
	update_gui()
	player.connect("state_changed", self, "on_player_state_changed")
	player.connect("mp_changed", self, "update_gui")
	player.connect("kitten_changed", self, "update_gui")


func on_player_state_changed():
	if(player.get_current_state() == player.STATE_FULL):
		mp_progress.texture_progress = load("res://images/gui/mp_full.png")
	elif(player.get_current_state() == player.STATE_HALF):
		mp_progress.texture_progress = load("res://images/gui/mp_full_orange.png")
	else:
		mp_progress.texture_progress = load("res://images/gui/mp_full_red.png")

func update_gui():
	mp_progress.value = player.get_current_mp()
	
	var format = "%d / %d"
	happy_cats_label.set_text(format % [player.get_current_kittens(), player.get_max_kittens()])

func update_timer():
	timer_label.set_text(global_data.get_time_string())

func update_time_of_day():
	if(global_data.get_current_time_of_day() == global_data.day_time):
		 time_of_day_label.set_texture(load("res://images/gui/day_label.png"))
	elif(global_data.get_current_time_of_day() == global_data.noon_time):
		time_of_day_label.set_texture(load("res://images/gui/noon_label.png"))
	elif(global_data.get_current_time_of_day() == global_data.night_time):
		time_of_day_label.set_texture(load("res://images/gui/night_label.png"))
