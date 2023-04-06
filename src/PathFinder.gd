extends RefCounted
class_name PathFinder

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

var _grid: Resource
var _astar := AStarGrid2D.new()

func _init(grid: Grid) -> void:
	_grid = grid
	_astar.size = grid.size
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar.update()
	
func calculate_point_path(start: Vector2i, end: Vector2i) -> PackedVector2Array:
	if _astar.is_in_bounds(end.x, end.y):
		return _astar.get_point_path(start, end)
	else:
		return PackedVector2Array()
