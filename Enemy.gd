extends "res://general.gd"

export(int) var patrol_distance = 200
var start_position = Vector2()
var end_position = Vector2()

enum STATES_MIND {WAIT, MOVE, ACT}
var current_mind_state = WAIT
var previous_mind_state = null

var last_move_direction = Vector2()
onready var wait_timer = $Timer

var first_ai_cycle = true

func _ready():
	start_position = position
	end_position = start_position + Vector2(patrol_distance, 0)

	_change_mind_state(WAIT)
	randomize()
	wait_timer.stop()
	wait_timer.wait_time = randf() * 3
	wait_timer.start()


func _physics_process(delta):
	motion.x = 100
	if current_mind_state == MOVE:
		if motion.x == 100 and position.x > end_position.x \
			or motion.x == -100 and position.x < start_position.x:
			last_move_direction = motion
			_change_mind_state(WAIT)


func _change_mind_state(new_state):
	previous_mind_state = current_mind_state
	current_mind_state = new_state

	match current_mind_state:
		WAIT:
			motion = Vector2()
			wait_timer.wait_time = 1.0
			wait_timer.start()
		MOVE:
			motion.x = -last_move_direction.x
			if last_move_direction.x == 0:
				motion.x = 100
			wait_timer.stop()


func _on_Timer_timeout():
	wait_timer.stop()
	if first_ai_cycle:
		first_ai_cycle = false
		_change_mind_state(MOVE)
		return

	_change_state(ATTACK)
	_change_mind_state(ACT)
#
#
func _on_Weapon_attack_finished():
	_change_mind_state(MOVE)
	_change_state(IDLE)

