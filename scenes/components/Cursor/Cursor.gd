@tool
extends Node2D
class_name Cursor

signal accept_pressed(cell)
signal moved(new_cell)

@export var grid : Resource = preload("res://scenes/components/Grid/Grid.tres")
@export var ui_cooldown := 0.1

@onready var _unit_path : TileMap = $"../UnitPath"
@onready var _game_board : GameBoard = $".."

@onready var _timer := $Timer

var cell := Vector2i.ZERO :
	get:
		return cell
	set(value):
		var new_cell: Vector2i = value
		if new_cell == cell:
			return
		cell = new_cell
		position = _unit_path.map_to_local(cell)
		emit_signal("moved", cell)
		_timer.start()

func _ready():
	_timer.wait_time = ui_cooldown
	position = _unit_path.map_to_local(cell)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		if grid.is_within_bounds(_unit_path.local_to_map(get_global_mouse_position())):
			self.cell = _unit_path.local_to_map(get_global_mouse_position())

	elif event.is_action_pressed("click") or event.is_action_pressed("ui_accept"):
		if _game_board._turn_manager.whos_turn == Unit.Team.player:
			emit_signal("accept_pressed", cell)
			get_viewport().set_input_as_handled()
	
	var should_move := event.is_pressed()
	
	if event.is_echo():
		should_move = should_move and _timer.is_stopped()

	if not should_move:
		return
	
	if event.is_action("ui_right"):
		self.cell += Vector2i.RIGHT
	elif event.is_action("ui_up"):
		self.cell += Vector2i.UP
	elif event.is_action("ui_left"):
		self.cell += Vector2i.LEFT
	elif event.is_action("ui_down"):
		self.cell += Vector2i.DOWN
	
func _draw():
	draw_rect(Rect2(-grid.cell_size / 2, grid.cell_size), Color.ALICE_BLUE, false, 2.0)
	var a = PackedVector2Array()

