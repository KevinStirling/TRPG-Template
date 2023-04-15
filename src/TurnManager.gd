extends Resource
class_name TurnManager

var whos_turn : Unit.Team
var turn_unit_list : Array[Unit]
var game_board : Node2D

var temp_timer : Timer

func _init(_units : Dictionary, _enemy_units : Dictionary) -> void :
	change_turns(_units)
	print(turn_unit_list)
	Events.next_player_turn.connect(new_turn)

func unit_moved(unit : Unit) -> void:
	turn_unit_list.erase(unit)
	print(turn_unit_list)
#	if turn_unit_list.size() == 0:
#		whos_turn = Unit.Team.player if whos_turn == Unit.Team.computer else Unit.Team.computer

func new_turn(units : Dictionary) -> void:
	print("we made it")
	pass

func change_turns(units : Dictionary) -> void:
	turn_unit_list.clear()
	for u in units :
		turn_unit_list.append(units[u])
	whos_turn = turn_unit_list[0].current_team
	print(whos_turn)
