extends Node


var turn_state : GlobalEnums.PlayerTurnState = GlobalEnums.PlayerTurnState.UPKEEP
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
var game_active : bool = false
var deck : Deck


func _ready():
	get_tree().node_added.connect(_on_node_added)
	get_tree().node_removed.connect(_on_node_removed)

## Management of Trigger Hooks and Turn Progression
func progress_turn():
	match turn_state:
		GlobalEnums.PlayerTurnState.UPKEEP:
			var triggers = get_tree().get_nodes_in_group("HasUpkeepTrigger")
			await execute_triggers(triggers, "OnUpkeepStepComponent")
			turn_state = GlobalEnums.PlayerTurnState.DRAW
		GlobalEnums.PlayerTurnState.DRAW:
			var triggers = get_tree().get_nodes_in_group("HasOnDrawTrigger")
			await execute_triggers(triggers, "OnDrawStepComponent")
			var drawn_card = deck
			turn_state = GlobalEnums.PlayerTurnState.ACTION
		GlobalEnums.PlayerTurnState.ACTION:
			var triggers = get_tree().get_nodes_in_group("HasEndOfActionTrigger")
			await execute_triggers(triggers, "OnEndOfActionStepComponent")
			turn_state = GlobalEnums.PlayerTurnState.END
		GlobalEnums.PlayerTurnState.END:
			var triggers = get_tree().get_nodes_in_group("HasEndOfTurnTrigger")
			await execute_triggers(triggers, "OnEndOfTurnComponent")
			turn_state = GlobalEnums.PlayerTurnState.OVER
		GlobalEnums.PlayerTurnState.OVER:
			var triggers = get_tree().get_nodes_in_group("HasBetweenTurnsTrigger")
			await execute_triggers(triggers, "OnBetweenTurnsComponent")
			turn_state = GlobalEnums.PlayerTurnState.UPKEEP


func execute_triggers(trigger_array : Array, trigger_node_name : String):
	for node in trigger_array:
		if node.has_node(trigger_node_name):
			var trigger_node : TriggerHookComponent = node.get_node(trigger_node_name)
			trigger_node.execute()
			await trigger_node.all_effects_completed
		else:
			print("Issue found with: ", node.name)


## Check for deck to hook onto
func _on_node_added(node):
	if node.is_in_group("IsDeck"):
		deck = node
		game_active = true
		deck.card_drawn.connect(_on_card_drawn)
		deck.card_added_to_deck.connect(_on_card_destroyed)


func _on_node_removed(node):
	if node.is_in_group("IsDeck"):
		game_active = false


## General Trigger Hook Management
func _on_card_destroyed(card : AbstractCard):
	if card.has_node("HasWhenDestroyedTrigger"):
		var when_destroyed_component = card.find_node("WhenDestroyedComponent")
		when_destroyed_component.execute()
	cards_in_play.erase(card)


func _on_card_drawn(drawn_card):
	var on_drawn_list = get_tree().get_nodes_in_group("HasOnCardDrawnTrigger")
	cards_in_play.append(drawn_card)
	if drawn_card.has_node("WhenDrawnComponent"):
		var when_drawn_component = drawn_card.find_node("WhenDrawnComponent")
		when_drawn_component.execute()
		await when_drawn_component.effect_completed
	
