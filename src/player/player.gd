extends KinematicBody2D

var motion = Vector2()
var time_since_on_floor = 0

const JUMP_HEIGHT = -600
const GRAVITY = 20
const SPEED = 300
const UP = Vector2(0, -1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
		$Sprite.flip_h = true
		$Sprite.play("walk")
	elif Input.is_action_pressed("ui_right"):
		motion.x = SPEED
		$Sprite.flip_h = false
		$Sprite.play("walk")
	else:
		motion.x = 0
		$Sprite.play("idle")
		
	if time_since_on_floor < 1:
		if Input.is_action_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
			time_since_on_floor = 1
	
	if is_on_floor():
		time_since_on_floor = 0
	else:
		time_since_on_floor += delta
		if motion.y < 0:
			$Sprite.play("jump")
		else:
			$Sprite.play("fall")
		
		
		
	motion = move_and_slide(motion, UP)
