extends Resource
class_name Grid

@export var size := Vector2(20, 20)
@export var cell_size := Vector2(80, 80)

var _half_cell_size = cell_size / 2

# map_to_local
func calculate_map_position( grid_position : Vector2) -> Vector2:
	return grid_position * cell_size +_half_cell_size

# local_to_map
func calculate_grid_coordinates( map_position : Vector2) -> Vector2:
	return (map_position / cell_size).floor()

func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var out := cell_coordinates.x >= 0 and cell_coordinates.x < size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y
	
func clamp(grid_position: Vector2) -> Vector2:
	var out := grid_position
	out.x = clamp(out.x, 0, size.x -1.0)
	out.y = clamp(out.y, 0, size.y - 1.0)
	return out
