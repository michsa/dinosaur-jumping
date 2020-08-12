extends KinematicBody2D

var MAX_RUN_SPEED = 50
var MAX_JUMP_SPEED = 500
var GRAVITY = 200
var MAX_JUMPS = 1

var run_speed = 0
var jump_speed = 0

var velocity = Vector2()
var jumps = 0

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
		run_speed = lerp(run_speed, MAX_RUN_SPEED, delta * 6)
	elif left:
		run_speed = lerp(run_speed, -MAX_RUN_SPEED, delta * 6)
	else:
		run_speed = lerp(run_speed, 0, delta * 8)
	
	velocity.y = GRAVITY - jump_speed 
	velocity.x = run_speed
	velocity = move_and_slide(velocity, Vector2(0, -1))
	for slide in get_slide_count():
		var collision = get_slide_collision(slide)
		if collision && !collision.collider.is_class('TileMap'): 
			collision.collider.take_hit(collision)
