extends Control
class_name CardSelectionScreen

signal card_chosen(chosen_card : AbstractCard, unchosen_cards : Array)

@export var card_container : HBoxContainer
@export var card_selection_button : PackedScene


func setup(cards_to_show : Array[AbstractCard]):
	for card : AbstractCard in cards_to_show:
		print_debug("Setting up:	", card.front_texture_location)
		var button : TextureButton = card_selection_button.instantiate()
		button.texture_normal = load(card.front_texture_location)
		cards_to_show.erase(card)
		button.pressed.connect(_on_card_selected.bind(card, cards_to_show))
		card_container.add_child(button)
		await get_tree().create_timer(0.1).timeout


func _on_card_selected(chosen_card : AbstractCard, unchosen_cards : Array):
	card_chosen.emit(chosen_card, unchosen_cards)
	queue_free()
