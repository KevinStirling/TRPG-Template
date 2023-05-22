extends Resource
class_name Grid

@export var cell_size := Vector2(40, 40)

var size := Vector2i(10, 10)
var grid_bounds : Array[Vector2i]

var _half_cell_size = cell_size / 2

# map_to_local
func calculate_map_position( grid_position : Vector2) -> Vector2:
	return grid_position * cell_size +_half_cell_size

# local_to_map
func calculate_grid_coordinates( map_position : Vector2) -> Vector2:
	return (map_position / cell_size).floor()

func is_within_bounds(cell_coordinates: Vector2i) -> bool:
	var out : int = cell_coordinates.x >= grid_bounds.min().x and cell_coordinates.x <= grid_bounds.max().x
	return out and cell_coordinates.y >= grid_bounds.min().y and cell_coordinates.y <= grid_bounds.max().y
	
func clamp(grid_position: Vector2) -> Vector2:
	var out := grid_position
	out.x = clamp(out.x, 0, size.x -1.0)
	out.y = clamp(out.y, 0, size.y - 1.0)
	return out
