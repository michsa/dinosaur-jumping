extends KinematicBody2D

var MAX_RUN_SPEED = 50
var MAX_JUMP_SPEED = 500
var GRAVITY = 200
var MAX_JUMPS = 1
var HITSTUN_DURATION = 0.5

var hp = 100

var run_speed = 0
var jump_speed = 0

var knockback = Vector2()
var velocity = Vector2()
var jumps = 0
var hitstun = 0

func take_hit(x, damage):
	if hitstun <= 0:
		hitstun = HITSTUN_DURATION
		$body.modulate = Color.orangered
		knockback.x = x * 250
		knockback.y = -400 if is_on_floor() else -100
		hp -= damage

func relation_to_player():
	return position - get_tree().root.get_node('tower/player').position

func _physics_process(delta):
	var relation_to_player = relation_to_player()
	
	var right = relation_to_player.x < 0
	var left = relation_to_player.x > 0
	var jumping = relation_to_player.y > 16 || (relation_to_player.y > -32 && is_on_wall())
	var jump = jumping && is_on_floor()
	
	if is_on_floor():
		jumps = 0
		jump_speed = 0
		velocity.y = 0

	if jump && jumps < MAX_JUMPS:
		jumps += 1
		jump_speed = MAX_JUMP_SPEED
	
	if jumping:
		jump_speed = lerp(jump_speed, 0, delta * (2 + jumps))
	else:
		jump_speed = lerp(jump_speed, 0, delta * (6 + jumps))
	
	if right:
		$body.scale.x = 1
		run_speed = lerp(run_speed, MAX_RUN_SPEED, delta * 6)
	elif left:
		$body.scale.x = -1
		run_speed = lerp(run_speed, -MAX_RUN_SPEED, delta * 6)
	else:
		run_speed = lerp(run_speed, 0, delta * 8)
	
	velocity.x = run_speed
	velocity.y = -jump_speed
	
	if hitstun > 0:
		hitstun -= delta
		velocity += knockback
		knockback *= hitstun / HITSTUN_DURATION
		$body.visible = int(hitstun * 10) % 2
	else:
		$body.modulate = Color.white
		$body.visible = true
	
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	for slide in get_slide_count():
		var collision = get_slide_collision(slide)
		if collision && !collision.collider.is_class('TileMap'):
			# we still want a good bit of knockback even when it isn't moving very fast
			var x = lerp(collision.travel.normalized().x, collision.travel.sign().x, 0.5)
			collision.collider.take_hit(x, 10)
