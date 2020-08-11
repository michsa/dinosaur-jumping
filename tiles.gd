extends TileMap



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var loc = Vector2(0, 0)

func world_to_tile_pos(pos):
	return map_to_world(world_to_map(pos)) + cell_size / 2

func set_tile(coords, tile):
	if get_cell(coords.x, coords.y) == 3: return
	set_cell(coords.x, coords.y, tile)
