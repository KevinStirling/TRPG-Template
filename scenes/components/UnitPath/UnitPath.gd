extends TileMap
class_name UnitPath

@export var grid: Resource

var _pathfinder: PathFinder

var current_path := PackedVector2Array()

func initialize(walkable_cells: Array) -> void:
	_pathfinder = PathFinder.new(grid, walkable_cells)

func draw(cell_start: Vector2, cell_end: Vector2) -> void:
	clear_layer(1)
	current_path = _pathfinder.calculate_point_path(cell_start, cell_end)
	set_cells_terrain_path(1,current_path, 0, 0)

func draw_walkable(cells: Array) -> void:
	clear_layer(0)
	for cell in cells:
		set_cell(0, cell, 0, Vector2.ZERO)

func stop() -> void:
	_pathfinder = null
	clear()
	
