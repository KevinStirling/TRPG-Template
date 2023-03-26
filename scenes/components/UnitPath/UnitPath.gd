extends TileMap
class_name UnitPath

@export var grid: Resource

var _pathfinder: PathFinder

var current_path := PackedVector2Array()

func initialize(walkable_cells: Array) -> void:
	_pathfinder = PathFinder.new(grid, walkable_cells)

func draw(cell_start: Vector2, cell_end: Vector2) -> void:
	clear()
	current_path = _pathfinder.calculate_point_path(cell_start, cell_end)
	set_cells_terrain_path(0 ,current_path, 0, 0)

func stop() -> void:
	_pathfinder = null
	clear()
	
func _ready():
	pass
#	var rect_start := Vector2(4, 4)
#	var rect_end := Vector2(10, 8)
#
#	var points := []
#
#	for x in rect_end.x - rect_start.x + 1:
#		for y in rect_end.y - rect_start.y + 1:
#			points.append(rect_start + Vector2(x,y))
#
#		initialize(points)
#		draw(rect_start, Vector2(8, 7))
