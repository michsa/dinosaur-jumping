extends Area2D

func _ready():
	set_physics_process(false)
	$anim.connect("animation_finished", self, 'done')

func attack():
	$anim.stop()
	$anim.play("swing")
	set_physics_process(true)

func done(anim):
	print(anim)
	print('done attacking')
	set_physics_process(false)

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('enemy'):
			body.take_hit($'..'.scale.x)
