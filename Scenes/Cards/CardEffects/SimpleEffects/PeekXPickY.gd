extends CardEffectComponent
class_name PeekXPickY

@export var num_peek : int = 3
@export var num_pick : int = 1

func execute():
	var peek_array = []
	for i in num_peek:
		peek_array.append(BoardManager.deck.peek_at_position(i))
	BoardManager.ui_manager.show_card_selection(peek_array)
	super.execute()
