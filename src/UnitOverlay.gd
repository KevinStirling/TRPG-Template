extends TileMap
class_name UnitOverlay

func draw(cells: Array) -> void:
	clear_layer(1)
	for cell in cells:
		set_cell(1, cell, 0, Vector2.ZERO)
