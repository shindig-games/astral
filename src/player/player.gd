extends KinematicBody2D

###   CONSTANTS   ###

const JUMP_HEIGHT = -600
const GRAVITY = 35
const SPEED = 300
const UP = Vector2(0, -1)

###   COMPONENTS   ###

var sprite = null

######################

var state_machine_class = preload("res://src/player/player_state_machine.gd")
var state_machine = null

var motion = Vector2()
var direction = 1
var time_since_on_floor = 0

func _ready():
	sprite = get_node("Sprite")
	
	state_machine = state_machine_class.new(self)
	state_machine.set_state(state_machine.states.idle)

func _physics_process(delta):
	always_apply_gravity(delta)
	
	if is_on_floor():
		motion.y = 0
		time_since_on_floor = 0
		
	state_machine.update(delta)

	motion = move_and_slide(motion, UP)

func play_anim(anim):
	$Sprite.play(anim)

func always_apply_gravity(delta):
	motion.y += GRAVITY		
	
func should_move(delta):
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		if time_since_on_floor == 0:
			return true
	return false	

func should_jump(delta):
	if time_since_on_floor < 1:
		if Input.is_action_pressed("ui_up"):
			return true

func should_idle(delta):
	if !should_move(delta) and !should_jump(delta):
		if time_since_on_floor == 0:
			return true
	return false

func should_fall(delta):
	if time_since_on_floor != 0 && motion.y > 0:
		return true
	return false
 
func apply_move(delta):
	if Input.is_action_pressed("ui_left"):
		if direction == 1:
			sprite.flip_h = true
		direction = -1
		motion.x = -SPEED		
	elif Input.is_action_pressed("ui_right"):
		if direction == -1:
			sprite.flip_h = false
		direction = 1
		motion.x = SPEED
	else:
		motion.x = 0

func apply_idle(delta):
	motion.x = 0

func apply_jump(delta):
	if time_since_on_floor < 1:
		motion.y = JUMP_HEIGHT
		time_since_on_floor = 1

func apply_fall(delta):
	pass
