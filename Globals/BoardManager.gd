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
var ui_manager : UIManager


func _ready():
	get_tree().node_added.connect(_on_node_added)
	get_tree().node_removed.connect(_on_node_removed)


## Management of Trigger Hooks and Turn Progression
func progress_turn():
	print("Look for triggers for phase:	", GlobalEnums.enum_string(turn_state, GlobalEnums.PlayerTurnState))
	match turn_state:
		GlobalEnums.PlayerTurnState.UPKEEP:
			await execute_turn("HasUpkeepStepTrigger", "OnUpkeepStepComponent", GlobalEnums.PlayerTurnState.DRAW)
		GlobalEnums.PlayerTurnState.DRAW:
			await draw_card()
			await execute_turn("HasOnDrawStepTrigger", "OnDrawStepComponent", GlobalEnums.PlayerTurnState.ACTION)
		GlobalEnums.PlayerTurnState.ACTION:
			await execute_turn("HasEndOfActionStepTrigger", "OnEndOfActionStepComponent", GlobalEnums.PlayerTurnState.END)
		GlobalEnums.PlayerTurnState.END:
			await execute_turn("HasOnEndOfTurnTrigger", "OnEndOfTurnStep", GlobalEnums.PlayerTurnState.OVER)
		GlobalEnums.PlayerTurnState.OVER:
			await execute_turn("HasBetweenTurnsTrigger", "OnBetweenTurnsComponent", GlobalEnums.PlayerTurnState.UPKEEP)
			deck.cards_drawn_this_turn = 0


func execute_turn(trigger_group : String, trigger_node_name : String, next_step : GlobalEnums.PlayerTurnState):
	var triggers = get_tree().get_nodes_in_group(trigger_group)
	print("	Current triggers in phase " + GlobalEnums.enum_string(turn_state, GlobalEnums.PlayerTurnState) + ":	", triggers)
	await execute_triggers(triggers, trigger_node_name)
	turn_state = next_step


func execute_triggers(trigger_array : Array, trigger_node_name : String):
	# print("Executing Triggers")
	for node in trigger_array:
		# print("		Hello")
		if node.has_node(trigger_node_name):
			# print("	Executing effects of card:	", node.name)
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
	cards_in_play.append(drawn_card)
	if drawn_card.has_node("WhenDrawnComponent"):
		var when_drawn_component = drawn_card.find_node("WhenDrawnComponent")
		when_drawn_component.execute()
		await when_drawn_component.effect_completed
	var on_drawn_list = get_tree().get_nodes_in_group("HasOnCardDrawnTrigger")
	await execute_triggers(on_drawn_list, "OnDrawStepComponent")


func draw_card():
	deck.draw()
