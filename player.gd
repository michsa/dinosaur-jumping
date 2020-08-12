extends KinematicBody2D

var MAX_RUN_SPEED = 120
var MAX_JUMP_SPEED = 500
var GRAVITY = 200
var MAX_JUMPS = 2
var HITSTUN_DURATION = 1.0

var hp = 100

var run_speed = 0
var jump_speed = 0

var knockback = Vector2()
var velocity = Vector2()
var jumps = 0

var hitstun = 0

func cursor_pos():
	return position + $cursor.cast_to

func take_hit(collision):
	if hitstun <= 0:
		hitstun = HITSTUN_DURATION
		modulate = Color.red
		# we still want a good bit of knockback even when enemy isn't moving very fast
		var x = lerp(collision.travel.normalized().x, collision.travel.sign().x, 0.5)
		knockback.x = x * 250
		knockback.y = -400 if is_on_floor() else -100
		hp -= 5

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
		target_run_speed = MAX_RUN_SPEED * 0.8

	if jump && jumps < MAX_JUMPS:
		jumps += 1
		jump_speed = MAX_JUMP_SPEED
	
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
	velocity.y = -jump_speed
	
	if hitstun > 0:
		hitstun -= delta
		velocity += knockback
		knockback = knockback * 0.9
	if hitstun <= 0:
		modulate = Color.white
		
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	
	$velocity.cast_to = velocity / 4
