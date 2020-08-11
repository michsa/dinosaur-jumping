extends Node2D

var radius = 48
var coords = Vector2(0, 0)
var show = false

func _process(delta):
	show = false
	var pos = $player.cursor_pos() # get_global_mouse_position()
	#if mouse_pos.distance_squared_to($player.position)
	coords = $tiles.world_to_map(pos)
	
	if $tiles.world_to_tile_pos(pos).distance_to($player.position) > 8 && $player/cursor.visible():
		show = true
		if Input.is_action_pressed('place_block'):
			$tiles.set_tile(coords, 2)
		if Input.is_action_pressed('remove_block'):
			$tiles.set_tile(coords, -1)
	update()

func box():
	var base_pos = $tiles.map_to_world(coords)
	return [
		base_pos + Vector2(0, 1),
		base_pos + Vector2(15, 0),
		base_pos + Vector2(15, 16),
		base_pos + Vector2(1, 16),
		base_pos + Vector2(0, 1)
	]

func _draw():
	if show:
		draw_rect(
			Rect2($tiles.map_to_world(coords), Vector2(16, 16)), 
			Color(0.1, 1.0, 0.3, 0.1)
		)
		draw_polyline(box(), Color(0.1, 1.0, 0.3, 0.3), 1.0)
