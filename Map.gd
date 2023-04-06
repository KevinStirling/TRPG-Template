extends Node2D

@export var grid : Resource

@onready var tilemap := $TileMap

func _ready():
	grid.grid_bounds = tilemap.get_used_cells(0)
#	probably can change the function that checks bounds and not
#	have to add a (1,1) vector
	grid.size = grid.grid_bounds.max() + Vector2i(1,1)
	print(grid.size)
