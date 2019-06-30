extends KinematicBody2D

var motion = Vector2()

const JUMP_HEIGHT = -600
const GRAVITY = 20
const SPEED = 300
const UP = Vector2(0, -1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	motion.y += GRAVITY
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y += JUMP_HEIGHT
	
	if Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		motion.x = SPEED
	else:
		motion.x = 0
		
	motion = move_and_slide(motion, UP)
