extends Node

var turn_state : GlobalEnums.PlayerTurnState
var mouse_ray : RayCast3D
var mouse_world_position : Vector3 = Vector3.ZERO
var camera : Camera3D
var ray_length : float = 30.0
var board_height : float = 0.5
var current_focus : Node3D
var last_focus : Node3D
var can_change_focus : bool = true
var focus_timer : float = 0.2
var time_since_focus_change : float = 0.0

var cards_in_play : Array[AbstractCard] = []

func _ready():
	get_tree().node_added.connect(_on_node_added)


func _process(delta : float):
	pass


func _on_node_added(node):
	if node.is_in_group("IsDeck"):
		var deck : Deck = node
		deck.card_drawn.connect(_on_card_drawn)
		deck.card_added_to_deck.connect(_on_card_destroyed)


func _on_draw(card: AbstractCard):
	cards_in_play.append(card)
	if card.has_node("OnDrawComponent"):
		card.get_node("OnDrawComponent").execute()


func _on_card_destroyed(card : AbstractCard):
	cards_in_play.erase(card)


func _on_upkeep():
	var upkeep_list = get_tree().get_nodes_in_group("HasUpkeepTrigger")
	for card in upkeep_list:
		var upkeep_component = card.find_child("OnUpkeepComponent")
		upkeep_component.execute()
		await upkeep_component.effect_completed


func _on_card_drawn(drawn_card):
	var on_drawn_list = get_tree().get_nodes_in_group("HasOnCardDrawnTrigger")
	cards_in_play.append(drawn_card)
	if drawn_card.has_node("WhenDrawnComponent"):
		var when_drawn_component = drawn_card.find_node("WhenDrawnComponent")
		when_drawn_component.execute()
		await when_drawn_component.effect_completed
		
	for card in on_drawn_list:
		var on_drawn_component = card.find_child("OnCardDrawnTrigger")
		on_drawn_component.execute()
		await on_drawn_component.effect_completed
	

func _on_end_of_action_step():
	var end_of_action_step_list = get_tree().get_nodes_in_group("HasEndOfActionStepTrigger")
	for card in end_of_action_step_list:
		var end_of_action_step_component = card.find_child("HasEndOfActionStepTrigger")
		end_of_action_step_component.execute()
		await end_of_action_step_component.effect_completed


func _on_end_of_turn():
	var end_of_turn_list = get_tree().get_nodes_in_group("HasEndOfTurnTrigger")
	for card in end_of_turn_list:
		var end_of_turn_step_component = card.find_child("OnEndOfTurnComponent")
		end_of_turn_step_component.execute()
		await end_of_turn_step_component.effect_completed
