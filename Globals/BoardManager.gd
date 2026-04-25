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


func _on_card_drawn(card: AbstractCard):
	cards_in_play.append(card)
	if card.has_node("OnDrawComponent"):
		card.get_node("OnDrawComponent").execute()


func _on_card_destroyed(card : AbstractCard):
	cards_in_play.erase(card)
