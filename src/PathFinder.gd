extends RefCounted
class_name PathFinder

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

var _grid: Resource
var _astar := AStarGrid2D.new()

func _init(grid: Grid) -> void:
	_grid = grid
	_astar.size = grid.size
	_astar.diagonal_mode = 1
	_astar.update()
	
func calculate_point_path(start: Vector2, end: Vector2) -> PackedVector2Array:
	if _astar.is_in_bounds(end.x, end.y):
		return _astar.get_point_path(start, end)
	else:
		return PackedVector2Array()
