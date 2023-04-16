extends Node2D
class_name GameBoard

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

@export var grid : Resource = preload("res://scenes/components/Grid/Grid.tres")

@onready var _unit_path : UnitPath = $UnitPath
@onready var _turn_tracker_text = $"../TurnUI/Control/TurnTracker/Text"
@onready var _end_turn_button = $"../TurnUI/Control/TurnTracker/EndTurnButton"

var _units := {}
var _active_unit : Unit
var _walkable_cells := []

var _enemy_units := {}

var _turn_manager : TurnManager

func _ready() -> void:
	Events.turn_ended.connect(func() -> void: 
		_turn_manager.change_turns(_units if _turn_manager.whos_turn == Unit.Team.computer else _enemy_units)
	)
	Events.turn_changed.connect(func(team) -> void :
		if team == Unit.Team.computer :
			_move_enemy_units()
	)
	_end_turn_button.pressed.connect(func() -> void: 
		_turn_manager.change_turns(_units if _turn_manager.whos_turn == Unit.Team.computer else _enemy_units)
	)
	Events.unit_moved.connect(_clear_active_unit)
	_reinitialize()

func _process(delta):
	_end_turn_button.visible = true if _turn_manager.whos_turn == Unit.Team.player else false
	_turn_tracker_text.text = "Your turn" if _turn_manager.whos_turn == Unit.Team.player else "Enemy moving"
	
func is_occupied(cell: Vector2) -> bool:
	return true if _units.has(cell) else false

func _reinitialize() -> void:
	_units.clear()
	
	for child in get_children():
		var unit := child as Unit
		if not unit:
			continue
		if unit.current_team == unit.Team.player :
			_units[unit.cell] = unit
		else :
			_enemy_units[unit.cell] = unit
	_turn_manager = TurnManager.new(_units)
	
func get_walkable_cells(unit: Unit) -> Array :
	return _flood_fill(_unit_path.local_to_map(unit.position), unit.move_range)
	
func _flood_fill(cell: Vector2, max_distance: int) -> Array:
	var array := []
	var stack := [cell]
	
	while not stack.is_empty():
		var current = stack.pop_back()
		
		if not grid.is_within_bounds(current):
			continue
		if current in array:
			continue
		
# Definitely clean this up later this is kinda gross
		if !_active_unit._move_pattern.is_empty():
			for c in _active_unit._move_pattern:
#				why is the position of the pattern being shifted on the y axis?
				if grid.is_within_bounds(c + current + Vector2(0,1)):
					array.append(c + current + Vector2(0,1))
			
			for direction in DIRECTIONS:
				var coordinates: Vector2 = current + direction
				if is_occupied(coordinates):
					continue
				if coordinates in array:
					continue
			
				stack.append(coordinates)
				return array
		
		var difference: Vector2 = (current - cell).abs()
		var distance := int(difference.x + difference.y)
		if distance > max_distance:
			continue
		
		array.append(current)
		
		for direction in DIRECTIONS:
			var coordinates: Vector2 = current + direction
			if is_occupied(coordinates):
				continue
			if coordinates in array:
				continue
			
			stack.append(coordinates)
	return array

func _move_enemy_units() -> void:
	var dest_cell
	for unit in _turn_manager.turn_unit_list:
		_active_unit = unit
		_active_unit.is_selected = true
		_walkable_cells = get_walkable_cells(_active_unit)
		_unit_path.draw_walkable(_walkable_cells)
		_unit_path.initialize()
		
		dest_cell = _walkable_cells.pick_random()
		while is_occupied(dest_cell): 
			dest_cell = _walkable_cells.pick_random()
		_unit_path.draw(_active_unit.cell, dest_cell)
		_move_active_unit(dest_cell)
		

func _select_unit(cell: Vector2) -> void:
	if _turn_manager.whos_turn != Unit.Team.player : return
	if not _units.has(cell):
		return
		
	_active_unit = _units[cell]
	_active_unit.is_selected = true
	_walkable_cells = get_walkable_cells(_active_unit)
	_unit_path.draw_walkable(_walkable_cells)
	_unit_path.initialize()
	
func _deselect_active_unit() -> void:
	_active_unit.is_selected = false
	_unit_path.clear_layer(1)
	_unit_path.stop()
	
func _clear_active_unit() -> void:
	_active_unit = null
	_walkable_cells.clear()
	
	
func _move_active_unit(new_cell: Vector2) -> void:
	if is_occupied(new_cell) or not new_cell in _walkable_cells:
		return
		
	if _turn_manager.whos_turn == Unit.Team.player:
		_units.erase(_active_unit.cell)
		_units[new_cell] = _active_unit
	elif _turn_manager.whos_turn == Unit.Team.computer:
		_enemy_units.erase(_active_unit.cell)
		_enemy_units[new_cell] = _active_unit
	
	_deselect_active_unit()
	_active_unit.walk_along(_unit_path.current_path)
	await _active_unit.walk_finished
	_turn_manager.unit_moved(_active_unit)
#	_clear_active_unit()


func _on_cursor_moved(new_cell: Vector2) -> void:
	if _active_unit and _active_unit.is_selected:
		_unit_path.draw(_active_unit.cell, new_cell)

func _on_cursor_accept_pressed(cell: Vector2) -> void:
	if not _active_unit:
		_select_unit(cell)
	elif _active_unit.is_selected:
		_move_active_unit(cell)

func _unhandled_input(event: InputEvent) -> void:
	if _active_unit and event.is_action_pressed("ui_cancel"):
		_deselect_active_unit()
		_clear_active_unit()
