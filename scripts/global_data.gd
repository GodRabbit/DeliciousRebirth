extends Node

const day_time = "DAY"
const night_time = "NIGHT"
const noon_time = "NOON"

var current_time_of_day = night_time

var seconds_passed = 0

var is_timer_on = true

var golden_kittens = 0

var total_deaths = 0

var records = {}
var last_record = {} # when the game ends its inserts its data to this dictionary
var ordered_records = [] # an array of record keys, ordered from least to most time
const save_file_path = "user://DelicousRebirth/records/%s.json"


signal time_of_day_changed

func _ready():
	set_process(true)

func _process(delta):
	if(is_timer_on):
		seconds_passed += delta

func start_timer():
	is_timer_on = true

func stop_timer():
	is_timer_on = false

# when starting a game don't forget to restart global data!!
func reset_global_data():
	seconds_passed = 0.0
	is_timer_on = true
	golden_kittens = 0
	total_deaths = 0
	current_time_of_day = night_time

# returns a dictionary with {"min":<number>, "sec":<number>}
# e.g. you enter 160 you'll get {"min":2, "sec":40}
func get_time_dic():
	var minutes = int(floor(seconds_passed)/60)
	var sec = seconds_passed - 60*minutes
	return {"min":minutes, "sec":sec}

func get_time_string():
	var d = global_data.get_time_dic()
	
	var secs = d["sec"]
	
	var sec_int = int(secs)
	var sec_f = int((secs - sec_int)*10.0) # the first digit after the period
	var format = "%02d : %02d.%d"
	return format % [d["min"], sec_int, sec_f]


func get_current_time_of_day():
	return current_time_of_day

# what turns the night cycle is the animation player on the main scene which updates via these functions:
func set_time_to_night():
	current_time_of_day = night_time
	emit_signal("time_of_day_changed")

func set_time_to_day():
	current_time_of_day = day_time
	emit_signal("time_of_day_changed")

func set_time_to_noon():
	current_time_of_day = noon_time
	emit_signal("time_of_day_changed")

func get_golden_kitties():
	return golden_kittens

func add_golden_kitten():
	golden_kittens += 1

func add_death():
	total_deaths += 1

func get_deaths():
	return total_deaths

# when the game ends call this function to store the current record
func create_current_record():
	var record_dic = {
		"seconds":seconds_passed,
		"deaths":total_deaths,
		"golden":golden_kittens
	}
	last_record = record_dic

func load_records():
	var file = File.new()
	if(file.file_exists(save_file_path % "records_data")): # if there is a record file, open it
		file.open(save_file_path % "records_data", file.READ)
		var text = file.get_as_text()
		var res = JSON.parse(text) #parse text to dictionary
		records = res.result #save the result
		file.close() #close file
	else:
		# create file with empty dictionary
		records = {}
		file.open(save_file_path % "records_data", file.WRITE)
		file.store_line(records)

# saves the record of the game
# DO NOT call this before game over!
func save_record():
	# load all the records:
	load_records()
	
	if(last_record.empty()): # if the current record wasn't recorded yet for some reason
		create_current_record() # saves the current record in last record
	
	# adds this new record to records dictionary:
	var id = str(records.size()+1)
	records[id] = last_record

# TODO finish this entire section
func _add_time_to_ordered_array(new_time, times_arr):
	pass

# order the records from least to most time passed
func order_records():
	var records_times = []
	var records_keys = []
	
	
