extends Node2D

@export var grid : Resource

@onready var tilemap := $TileMap

func _ready():
	grid.grid_bounds = tilemap.get_used_cells(0)
#	grid.size = Vector2i(grid.grid_bounds.max().x - (grid.grid_bounds.min().x -1 ), grid.grid_bounds.max().y - (grid.grid_bounds.min().y -1))
	print(grid.size)
