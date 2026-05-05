extends CanvasLayer
class_name UIManager

@export var card_selection_screen_scene : PackedScene


func _ready():
	BoardManager.ui_manager = self
	#var test_array : Array[AbstractCard] = []
	#for card in test_cards:
		#var new_card = card.instantiate()
		#test_array.append(new_card)
	#show_card_selection(test_array)


func show_card_selection(cards: Array) -> Node:
	var screen : CardSelectionScreen = card_selection_screen_scene.instantiate()
	add_child(screen)
	var show_array = []
	for card in cards:
		var new_card = card.instantiate()
		show_array.append(new_card)
	screen.setup(show_array)
	#screen.card_chosen.connect(handle_card_chosen)
	return screen


#func handle_card_chosen(card : AbstractCard):
	#print(card.name)
