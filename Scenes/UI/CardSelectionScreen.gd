extends Control
class_name CardSelectionScreen

signal card_chosen(chosen_card : AbstractCard)

var cards : Array[AbstractCard] = []

@export var card_container : HBoxContainer
@export var card_selection_button : PackedScene


func setup(cards_to_show : Array[AbstractCard]):
	for card : AbstractCard in cards_to_show:
		print_debug("Setting up:	", card.front_texture_location)
		var button : TextureButton = card_selection_button.instantiate()
		button.texture_normal = load(card.front_texture_location)
		button.pressed.connect(_on_card_selected.bind(card))
		card_container.add_child(button)
		await get_tree().create_timer(0.1).timeout


func _on_card_selected(chosen_card : AbstractCard):
	for card in cards:
		if card != chosen_card:
			card.queue_free()
	card_chosen.emit(chosen_card)
	queue_free()
