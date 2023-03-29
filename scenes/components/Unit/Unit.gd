@tool
extends Path2D
class_name Unit

signal walk_finished

@onready var _sprite := $PathFollow2D/Sprite
@onready var _anim_player := $AnimationPlayer
@onready var _path_follow := $PathFollow2D

@export var grid: Resource = preload("res://scenes/components/Grid/Grid.tres")
@export var move_range := 6
@export var skin : Texture:
	get: 
		return skin
	set(value):
		skin = value
		if not _sprite:
			await self.ready
		_sprite.texture = value
		
@export var skin_offset := Vector2.ZERO :
	get:
		return skin_offset
	set(value):
		skin_offset = value
		if not _sprite:
			await self.ready
		_sprite.position = value

@export var move_speed := 600.0

var cell := Vector2.ZERO :
	get:
		return cell
	set(value):
		cell = grid.clamp(value)
	
var is_selected := false :
	get:
		return is_selected
	set(value):
		is_selected = value
		if is_selected:
			_anim_player.play("selected")
		else:
			_anim_player.play("idle")

var _is_walking := false :
	get:
		return _is_walking
	set(value):
		_is_walking = value
		set_process(_is_walking)


func _ready() -> void:
	set_process(false)
	self.cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(cell)
	
	if not Engine.is_editor_hint():
		curve = Curve2D.new()

func _process(delta) -> void:
	_path_follow.progress += move_speed * delta
	if _path_follow.progress_ratio >= 1.0:
		self._is_walking = false
		_path_follow.progress = 0.0
		position = grid.calculate_map_position(cell)
		curve.clear_points()
		emit_signal("walk_finished")
		
func walk_along(path: PackedVector2Array) -> void:
	if path.is_empty():
		return
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calculate_map_position(point) - position)
		cell = path[-1]
		self._is_walking = true
