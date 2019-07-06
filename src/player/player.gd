extends KinematicBody2D

###   CONSTANTS   ###

const GRAVITY = 25

const SPEED = 300
const SPRINT_SPEED = 500

const JUMP_SPEED = -600

const WALL_SLIDE_SPEED = 200

const WALL_JUMP_SPEED_Y = -700
const WALL_JUMP_SPEED_X = 200

###   COMPONENTS   ###

onready var sprite = get_node("Sprite")
onready var rays = get_node("Raycasts")

######################

var state_machine_class = preload("res://src/player/player_state_machine.gd")
var state_machine = null

const UP = Vector2(0, -1)
var motion = Vector2()
var direction = 1
var wall_direction = 1
var wall_jump_direction = 0

var time_since_on_floor = 0

var lock_move_left_timer = 0
var lock_move_right_timer = 0
var lock_move_stop_timer = 0

func _ready():
	state_machine = state_machine_class.new(self)
	state_machine.set_state(state_machine.states.idle)

func _physics_process(delta):
	always_apply_gravity(delta)
	
	update_timers(delta)
	
	if is_on_floor():
		motion.y = 0
		wall_jump_direction = 0
		time_since_on_floor = 0
	else:
		time_since_on_floor += delta
				
	state_machine.update(delta)

	motion = move_and_slide(motion, UP)

func update_timers(delta):
	if lock_move_left_timer > 0:
		lock_move_left_timer -= delta

	if lock_move_right_timer > 0:
		lock_move_right_timer -= delta
		
	if lock_move_stop_timer > 0:
		lock_move_stop_timer -= delta

func play_anim(anim):
	$Sprite.play(anim)

# warning-ignore:unused_argument
func always_apply_gravity(delta):
	motion.y += GRAVITY		
	
func check_wall_collision():
	if rays.get_child(0).is_colliding() or rays.get_child(1).is_colliding():
		return 1
	if rays.get_child(2).is_colliding() or rays.get_child(3).is_colliding():
		return -1
	return 0

###   STATE MACHINE   ###

# warning-ignore:unused_argument
func should_move(delta):
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		if time_since_on_floor == 0:
			return true
	return false	

# warning-ignore:unused_argument
func should_jump(delta):
	if time_since_on_floor < 1:
		if Input.is_action_pressed("move_jump"):
			return true

func should_idle(delta):
	if time_since_on_floor == 0:
		if !should_move(delta) and !should_jump(delta) and !should_crouch(delta):
			return true
	return false

# warning-ignore:unused_argument
func should_fall(delta):
	if check_wall_collision() != 0 and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		return false
	if time_since_on_floor > 0.25:
		return true
	return false
	
# warning-ignore:unused_argument
func should_wall_slide(delta):
	wall_direction = check_wall_collision()
	if (wall_direction != wall_jump_direction) and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		if wall_direction != 0:
			return true
	return false

# warning-ignore:unused_argument
func should_wall_jump(delta):
	if Input.is_action_just_pressed("move_jump"):
		wall_direction = check_wall_collision()
		if wall_direction == 1 and Input.is_action_pressed("move_right"):
			return true
		if wall_direction == -1 and Input.is_action_pressed("move_left"):
			return true
	return false
	
func should_crouch(delta):
	if Input.is_action_pressed("ui_down"):
		if time_since_on_floor == 0:
			return true
	return false
 
# warning-ignore:unused_argument
func apply_move(delta):
	if Input.is_action_pressed("move_left") and lock_move_left_timer <= 0:
		if direction == 1:
			sprite.flip_h = true
		direction = -1
		motion.x = -SPEED
				
	elif Input.is_action_pressed("move_right") and lock_move_right_timer <= 0:
		if direction == -1:
			sprite.flip_h = false
		direction = 1
		motion.x = SPEED
	
	elif lock_move_stop_timer <= 0:
		motion.x = 0
		

# warning-ignore:unused_argument
func apply_idle(delta):
	motion.x = 0

# warning-ignore:unused_argument
func apply_jump(delta):
	if time_since_on_floor < 1:
		motion.y = JUMP_SPEED
		time_since_on_floor = 1

# warning-ignore:unused_argument
func apply_fall(delta):
	pass

# warning-ignore:unused_argument
func apply_wall_slide(delta):
	motion.y = min(motion.y, WALL_SLIDE_SPEED)

# warning-ignore:unused_argument
func apply_wall_jump(delta):
	if wall_direction == 1:
		lock_move_right_timer = 0.5
	if wall_direction == -1:
		lock_move_left_timer = 0.5
	motion.x = wall_direction * -WALL_JUMP_SPEED_X
	motion.y = WALL_JUMP_SPEED_Y
	wall_jump_direction = wall_direction
	time_since_on_floor = 1
	lock_move_stop_timer = 0.5
	
func apply_crouch(delta):
	motion.x = 0
	apply_move(delta)
	