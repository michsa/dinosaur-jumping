extends RayCast2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var radius = 48

var time_since_moved = 0

func visible():
	return cast_to.length() > 10

# Called when the node enters the scene tree for the first time.
func _ready():
	enabled = true
	pass # Replace with function body.

func _process(delta):
	var offset = Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3)) * 6
	if offset.length() < 1:
		time_since_moved += delta
		if time_since_moved > 0.8:
			cast_to = Vector2(0, 0)
	else:
		time_since_moved = 0
		cast_to += offset
		cast_to = cast_to.clamped(radius)
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	if visible(): draw_circle(cast_to, 4, Color(0.8, 0.8, 0.6, 0.7))
