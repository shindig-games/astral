extends KinematicBody2D

var motion = Vector2()

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
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y += JUMP_HEIGHT
	else:
		if motion.y < 0:
			$Sprite.play("jump")
		else:
			$Sprite.play("fall")
		
		
		
	motion = move_and_slide(motion, UP)
