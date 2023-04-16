extends TileMap
class_name UnitPath

@export var grid: Resource

var _pathfinder: PathFinder

var current_path := PackedVector2Array()

func initialize() -> void:
	_pathfinder = PathFinder.new(grid)

func draw(cell_start: Vector2i, cell_end: Vector2i) -> void:
	clear_layer(1)
	current_path = _pathfinder.calculate_point_path(cell_start, cell_end)
	for p in current_path:
		set_cell(1, p, 3, Vector2.ZERO)

func draw_walkable(cells: Array) -> void:
	clear_layer(0)
	for cell in cells:
		set_cell(0, cell, 2, Vector2.ZERO)

func stop() -> void:
	_pathfinder = null
	clear()
