extends Resource
class_name TurnManager

var whos_turn : Unit.Team :
	get:
		return whos_turn
	set(value):
		whos_turn = value
		Events.turn_changed.emit(whos_turn)

var turn_unit_list : Array[Unit]
var game_board : Node2D

func _init(_units : Dictionary) -> void :
	change_turns(_units)

func unit_moved(unit : Unit) -> void:
	turn_unit_list.erase(unit)
	Events.unit_moved.emit()
	if turn_unit_list.size() == 0:
		Events.turn_ended.emit()

func change_turns(units : Dictionary) -> void:
	turn_unit_list.clear()
	for u in units :
		turn_unit_list.append(units[u])
	whos_turn = turn_unit_list[0].current_team
