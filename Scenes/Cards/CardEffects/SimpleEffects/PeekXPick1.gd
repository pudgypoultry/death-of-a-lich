extends CardEffectComponent
class_name PeekXPick1

@export var num_peek : int = 3

var chosen_cards = []
var unchosen_cards = []

func execute():
	var peek_array = []
	for i in num_peek:
		peek_array.append(BoardManager.deck.peek_at_position(i))
	
	var pick_screen : CardSelectionScreen = BoardManager.ui_manager.show_card_selection(peek_array)
	var result = await pick_screen.card_chosen
	handle_card_chosen(result[0], result[1])
	super.execute()


func handle_card_chosen(chosens : AbstractCard, unchosens : Array):
	chosen_cards.append(chosens)
	unchosen_cards = unchosens
	for unchosen_card : AbstractCard in unchosen_cards:
		BoardManager.deck.add_card_to_top(unchosen_card)
	for chosen_card in chosen_cards:
		act_on_choice(chosen_card)


func act_on_choice(card):
	print("Player chose:	", card)
