extends "res://general.gd"


func _physics_process(delta):
	
	if Input.is_action_pressed("move_right"):
		motion.x = min(motion.x+ACCELERATION,MAX_SPEED)
		if current_state == ATTACK:
			return
		$Weaponslot.set_scale(look_right)
		sprite.flip_h = true
		if current_state == RUN:
			sprite.play("run")

	elif Input.is_action_pressed("move_left"):
		motion.x = max(motion.x-ACCELERATION,-MAX_SPEED)
		if current_state == ATTACK:
			return
		$Weaponslot.set_scale(look_left)
		sprite.flip_h = false
		if current_state == RUN:
			sprite.play("run")
	else:
		friction = true
		
	if is_on_floor():
			if Input.is_action_just_pressed("jump"):
				motion.y = JUMP_HEIHGHT
			if friction == true:
				motion.x = lerp(motion.x,0,0.2)

	else:
		sprite.play("jump")
		motion.x = lerp(motion.x,0,0.1)

func _input(event):
	if event.is_action_pressed("attack"):
		if current_state in [STAGGER,ATTACK,DIE,DEAD]:
			return
		_change_state(ATTACK)
