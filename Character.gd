#Playerphysics.gd
extends KinematicBody2D
const UP = Vector2(0,-1)
const GRAVITY = 20
const MAX_SPEED = 200
const JUMP_HEIHGHT = -300
const ACCELERATION = 50

var motion = Vector2()


func _physics_process(delta):
	
	motion.y += GRAVITY
	var friction = false
	
	if Input.is_action_pressed("move_right"):
		motion.x = min(motion.x+ACCELERATION,MAX_SPEED)
		#$Character.flip_h = false
		#$Sprite.play("Run")
	elif Input.is_action_pressed("move_left"):
		motion.x = max(motion.x-ACCELERATION,-MAX_SPEED)
		#$Character.flip_h = true
		#$Sprite.play("Run")
	else:
		#$Sprite.play("Idle")
		friction = true
		
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = JUMP_HEIHGHT
		if friction == true:
			motion.x = lerp(motion.x,0,0.2)
	else:
		#if motion.y < 0:
		# $Sprite.play("Jump")
		#else:
			#$Sprite.play("Fall")
		if friction == true:
			motion.x = lerp(motion.x,0,0.05)


	motion = move_and_slide(motion,UP)
	pass