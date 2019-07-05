extends "res://src/state/finite_state_machine.gd"

class_name PlayerStateMachine

func _init(p):
	add_state("idle")
	add_state("walk")
	add_state("jump")
	add_state("fall")
	parent = p

func _state_logic(delta):
	match state:
		states.idle:
			parent.apply_idle(delta)
		states.walk:
			parent.apply_move(delta)
		states.jump:
			parent.apply_jump(delta)
			parent.apply_move(delta)
		states.fall:
			parent.apply_fall(delta)

func _get_transition(delta):
	match state:
		
		states.idle:
			if parent.should_move(delta):
				return states.walk
			if parent.should_jump(delta):
				return states.jump
				
		states.walk:
			if parent.should_idle(delta):
				return states.idle
			if parent.should_jump(delta):
				return states.jump
			if parent.should_fall(delta):
				return states.fall
		
		states.jump:
			if parent.should_fall(delta):
				return states.fall
		
		states.fall:
			if parent.should_idle(delta):
				return states.idle	
			if parent.should_move(delta):
				return states.walk
			
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		
		states.idle:
			parent.play_anim("idle")
		
		states.walk:
			parent.play_anim("walk")
			if parent.direction == 1:
				parent.sprite.flip_h = false
			else:
				parent.sprite.flip_h = true
				
		states.jump:
			parent.play_anim("jump")
		
		states.fall:
			parent.play_anim("fall")

func _exit_state(old_state, new_state):
	pass