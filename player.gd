extends KinematicBody2D

var MAX_RUN_SPEED = 150
var MAX_JUMP_SPEED = 400
var GRAVITY = 200
var MAX_JUMPS = 2

var hp = 100

var run_speed = 0
var jump_speed = 0

var velocity = Vector2()
var jumps = 0

func cursor_pos():
	return position + $cursor.cast_to

func _physics_process(delta):
	$hp_bar.value = hp
	
	var right = Input.is_action_pressed('right')
	var left = Input.is_action_pressed('left')
	var jumping = Input.is_action_pressed('jump')
	var jump = Input.is_action_just_pressed('jump')
	var attack = Input.is_action_just_pressed('attack')
	
	if attack:
		$body/weapon.attack()
	
	var target_run_speed
	if is_on_floor():
		jumps = 0
		jump_speed = 0
		velocity.y = 0
		target_run_speed = MAX_RUN_SPEED
	else:
		target_run_speed = 100

	if jump && jumps < MAX_JUMPS:
		jumps += 1
		jump_speed = 500
	
	if jumping:
		jump_speed = lerp(jump_speed, 0, delta * (2 + jumps))
	else:
		jump_speed = lerp(jump_speed, 0, delta * (6 + jumps))
	
	if right:
		$body.scale.x = 1
		run_speed = lerp(run_speed, target_run_speed, delta * 4)
	elif left:
		$body.scale.x = -1
		run_speed = lerp(run_speed, -target_run_speed, delta * 4)
	else:
		run_speed = lerp(run_speed, 0, delta * 10)
	
	velocity.x = run_speed
	velocity.y = GRAVITY - jump_speed
	velocity = move_and_slide(velocity, Vector2(0, -1))
