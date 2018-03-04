extends KinematicBody2D

signal health_changed
signal dead
signal died

export(String) var weapon_scene_path = "res://Dragonslayer.tscn"

const UP = Vector2(0,-1)
const GRAVITY = 20
var MAX_SPEED = 320
const JUMP_HEIHGHT = -450
const ACCELERATION = 50

var motion = Vector2()
var look_right = Vector2(1,1)
var look_left = Vector2(-1,1)

enum STATES {STAGGER,IDLE,RUN,DIE,DEAD,ATTACK}
var sprite

var current_state = null
var previous_state = null
var friction
var weapon = null
var weapon_path = ""

onready var animation_player = $AnimationPlayer
onready var move_player = $body/MovePlayer



export var max_health = 1
var health
var damage

func _ready():
	health = max_health
	sprite = $body
	
	###################____WEAPON SETUP____####################
	
	var weapon_instance = load(weapon_scene_path).instance()
	var weapon_anchor = $Weaponslot/Weaponanchor
	weapon_anchor.add_child(weapon_instance)
	weapon = weapon_anchor.get_child(0)
	weapon_path = weapon.get_path()
	weapon.connect("attack_finished",self, "_on_Weapon_attack_finished")
	#_on_Weapon_attack_finished ::::::::: enemy function
	_change_state(IDLE)
	
func _physics_process(delta):

	if current_state == IDLE:
		if motion:
			_change_state(RUN)
			MAX_SPEED = 320

	if current_state == RUN:
		if not motion:
			_change_state(IDLE)
	
	motion.y += GRAVITY
	friction = false
	motion = move_and_slide(motion,UP)
	
func _change_state(new_state):
	previous_state = current_state
	current_state = new_state
	
	match new_state:
		IDLE:
			sprite.play("idle")
		ATTACK:
			MAX_SPEED = 100
			sprite.play("attack")
			weapon.attack()
		STAGGER:
			animation_player.play("damaged")
		DEAD:
			queue_free()

func take_damage(count):
	if current_state == DEAD:
		return
	
	health -=count
	if health <=0:
		health = 0
		_change_state(DEAD)
		emit_signal("died")
		return
		
	_change_state(STAGGER)
	emit_signal("health_changed", health)
	
func _on_Damaged_animation_finished(name):
	if name == "damaged":
		_change_state(IDLE)
	
func _on_Weapon_attack_finished():
	_change_state(IDLE)
