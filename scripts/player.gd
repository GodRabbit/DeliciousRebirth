extends KinematicBody2D

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


const gravity = 1300.0

const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 800 # 800 seems good
const WALK_MIN_SPEED = 30 # 10?
const WALK_MAX_SPEED = 280 # 300? is kinds good
const STOP_FORCE = 900 # 800 too low??
const JUMP_SPEED = 200
const JUMP_MAX_AIRBORNE_TIME = 0.2

const FACE_LEFT = "FACE_LEFT"
const FACE_RIGHT = "FACE_RIGHT"

const STATE_FULL = "STATE_FULL"
const STATE_HALF = "STATE_HALF"
const STATE_QUARTER = "STATE_QUARTER"

const DAY_MELTING_RATE = 1.2 # 1.2
const NOON_MELTING_RATE = 1.8 # 1.8

const max_kittens = 7
var current_kittens = 0

var velocity = Vector2()
#var force = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false

# these variables control the "hold jump for longer >> jump higher"
var jumping_pressed = false
const max_jump_duration = 0.5 # seconds
var current_jump_duration = 0.0

var current_facing = FACE_RIGHT

var current_state = STATE_QUARTER

var current_mp = 100.0 # melting points # at 0 you die
var max_mp = 100.0

var is_dead = false

# signals:
signal state_changed
signal mp_changed
signal death
signal kitten_changed
signal game_won

func _ready():
	set_physics_process(true)
	set_process_input(true)
	
	$hud.set_player(self)
	
	update_state()

func _input(event):
	if(event.is_action_pressed("debug_hurt")):
		#add_mp(-10)
		add_kitten()
	elif(event.is_action_pressed("debug_golden")):
		global_data.add_golden_kitten()

func reset_jump():
	jumping_pressed = false
	current_jump_duration = 0.0

func _physics_process(delta):
	# update melting points:
	if(!is_dead && global_data.get_current_time_of_day() == global_data.day_time):
		 add_mp(-DAY_MELTING_RATE*delta)
	elif(!is_dead && global_data.get_current_time_of_day() == global_data.noon_time):
		add_mp(-NOON_MELTING_RATE*delta)
	
	# Create forces
	var force = Vector2(0, gravity)
	
	# while the player hold the jump button, gravity is cancelled
	if(jumping_pressed && current_jump_duration < max_jump_duration): 
		force = Vector2(0, 0)
	
	var walk_left = Input.is_action_pressed("ui_left")
	var walk_right = Input.is_action_pressed("ui_right")
	var jump = Input.is_action_pressed("ui_up")
	
	var stop = true
	
	if(not jump):
		reset_jump()
	
	if walk_left:
		set_facing(FACE_LEFT)
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		set_facing(FACE_RIGHT)
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
	
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	# Integrate forces to velocity
	velocity += force * delta
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not jumping: #this is the off-the-ground jump
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
		jumping_pressed = true
	elif(jump && jumping_pressed): # controls the "Hold longer >> jump higher" part
		velocity.y = -JUMP_SPEED*1.2
		current_jump_duration += delta
		if(current_jump_duration >= max_jump_duration):
			reset_jump()
	
	on_air_time += delta
	prev_jump_pressed = jump

func set_facing(side):
	if(side == FACE_LEFT):
		$body.scale = Vector2(-1, 1)
	else:
		$body.scale = Vector2(1, 1)

func update_state():
	var half = 0.5 * get_max_mp()
	var quart = 0.25 * get_max_mp()
	if(current_mp > half && current_state != STATE_FULL):
		current_state = STATE_FULL
		
		# set the sprite to full body
		$body.set_texture(load("res://images/body_full.png"))
		
		# enable the right collision
		$coll_full.disabled = false
		# disable the 2 other collision:
		$coll_quarter.disabled = true
		$coll_half.disabled = true
		emit_signal("state_changed")
	elif(current_mp <= half && current_mp > quart && current_state != STATE_HALF):
		current_state = STATE_HALF
		
		# set the sprite to half body
		$body.set_texture(load("res://images/body_half.png"))
		
		# enable the right collision
		$coll_half.disabled = false
		# disable the 2 other collision:
		$coll_quarter.disabled = true
		$coll_full.disabled = true
		emit_signal("state_changed")
	elif(current_mp <= quart && current_state != STATE_QUARTER):
		current_state = STATE_QUARTER
		
		# set the sprite to quarter body
		$body.set_texture(load("res://images/body_quarter.png"))
		
		# enable the right collision
		$coll_quarter.disabled = false
		# disable the 2 other collision:
		$coll_full.disabled = true
		$coll_half.disabled = true
		emit_signal("state_changed")

func get_max_mp():
	return max_mp

func get_current_mp():
	return current_mp

func set_current_mp(val):
	if(val <= 0):
		current_mp = 0
		emit_signal("death")
		on_death()
	elif(val >= get_max_mp()):
		current_mp = get_max_mp()
	else:
		current_mp = val
	update_state()
	emit_signal("mp_changed")

func add_mp(val):
	set_current_mp(get_current_mp() + val)

func get_current_state():
	return current_state

func get_max_kittens():
	return max_kittens

func get_current_kittens():
	return current_kittens

func add_kitten():
	current_kittens += 1
	emit_signal("kitten_changed")
	if(current_kittens == max_kittens):
		emit_signal("game_won")

func kill_player():
	add_mp(-1000) # a bit over kill

func on_death():
	# call death animation [which calls respawn!]
	if(!is_dead):
		is_dead = true
		global_data.add_death() # counts the number of deaths
		$anim.play("death")
		

# called from within the animation 
func respawn_player():
	add_mp(100) # you get the starting hp
	is_dead = false
	
	# return to idle animation:
	$anim.play("idle")
	
	# teleport player to starting position:
	global_position = Vector2(390, 490)