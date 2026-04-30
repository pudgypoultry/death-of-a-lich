extends CanvasLayer

@export var turn_phase_label : Label


func _process(delta):
	turn_phase_label.text = "Current Phase: " + GlobalEnums.enum_string(BoardManager.turn_state, GlobalEnums.PlayerTurnState)


func _progress_turn():
	print("Progressing Turn...")
	BoardManager.progress_turn()
