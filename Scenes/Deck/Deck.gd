extends Node3D
class_name Deck

@export var cards : Array[PackedScene] = []
@export var draw_position : Node3D
@export var deck_visual : DeckVisual
@export var shuffle_sounds : AudioStreamPlayer3D

signal card_drawn(card)
signal peeked(card)
signal shuffled
signal card_added_to_deck(card)
signal deck_emptied()


## Takes a PackedScene relating to a card and instantiates then returns it
func InstantiateCard(card_scene : PackedScene) -> AbstractCard:
	var card : AbstractCard = card_scene.instantiate()
	return card


func pack_card(card_to_pack : AbstractCard) -> PackedScene:
	var return_scene = PackedScene.new()
	return_scene.pack(card_to_pack)
	return return_scene


## Shuffles the deck, just calls Array.shuffle()
func shuffle():
	shuffled.emit()
	if deck_visual:
		deck_visual.shuffle_animation()
	cards.shuffle()


## The next three pop a card PackedScene from the deck's array
func draw() -> AbstractCard:
	var new_card = cards.pop_front()
	var card_scene : AbstractCard = InstantiateCard(new_card)
	get_tree().root.add_child(card_scene)
	card_drawn.emit(card_scene)
	card_scene.global_position = draw_position.global_position
	return card_scene


func draw_from_bottom() -> AbstractCard:
	var new_card = cards.pop_back()
	var card_scene : AbstractCard = InstantiateCard(new_card)
	get_tree().root.add_child(card_scene)
	card_drawn.emit(card_scene)
	card_scene.global_position = draw_position.global_position
	return card_scene


func draw_from_position(pos : int) -> AbstractCard:
	var new_card = cards.pop_at(pos)
	var card_scene : AbstractCard = InstantiateCard(new_card)
	get_tree().root.add_child(card_scene)
	card_drawn.emit(card_scene)
	card_scene.global_position = draw_position.global_position
	return card_scene


## The next three add a card PackedScene to the deck's array
func add_card_at_position(pos : int, card_to_add : AbstractCard):
	card_added_to_deck.emit(card_to_add)
	cards.insert(pos, pack_card(card_to_add))


func add_card_to_top(card_to_add : AbstractCard):
	add_card_at_position(0, card_to_add)


func add_card_to_bottom(card_to_add : AbstractCard):
	add_card_at_position(-1, card_to_add)


## The next three peek at a card PackedScene from the deck's array
func peek_at_position(pos : int) -> PackedScene:
	peeked.emit(cards[pos])
	return cards[pos]


func peek_at_top() -> PackedScene:
	return peek_at_position(0)


func peek_at_bottom() -> PackedScene:
	return peek_at_position(-1)


## Clears the deck's card array
func empty_deck():
	deck_emptied.emit()
	cards = []
