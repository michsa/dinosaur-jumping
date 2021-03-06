extends RayCast2D

var STICK_DURATION = 0.8

var radius = 48
var time_to_reset = STICK_DURATION

func visible():
	return cast_to.length() > 10

# Called when the node enters the scene tree for the first time.
func _ready():
	enabled = true
	pass # Replace with function body.

# maps cursor directly to the joypad axis
func process_quick_cursor():
	cast_to = Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3)) * radius
	return visible()
	

# uses joypad input to move cursor.
# better control, but feels less juicy
func process_sticky_cursor(delta):
	var offset = Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3)) * 6
	if offset.length() < 1:
		time_to_reset -= delta
		if time_to_reset <= 0:
			cast_to = Vector2(0, 0)
	else:
		time_to_reset = STICK_DURATION
		cast_to += offset
		cast_to = cast_to.clamped(radius)
		return true

# fallback
func process_mouse_cursor():
	var mouse_pos = get_global_mouse_position()
	var pos = $'..'.position
	if mouse_pos.distance_squared_to(pos) < radius * radius:
		cast_to = mouse_pos - pos
		return true

func _physics_process(delta):
	process_quick_cursor() || process_mouse_cursor()
	if cast_to.x < -10:
		$'../body'.scale.x = -1
	if cast_to.x > 10:
		$'../body'.scale.x = 1
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	if visible(): draw_circle(cast_to, 4, Color(0.8, 0.8, 0.6, time_to_reset))
