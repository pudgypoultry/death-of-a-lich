extends Node
class_name DragAndDropComponent

@export var check_ray : RayCast3D
@export var pickup_height : float
@export var drag_speed : float = 10.0
@export var valid_drops : Array
@export var slottable_component : SlottableComponent
@export var debug : bool = false

var actor_reference : Node3D
var is_current_focus : bool = false
var is_being_dragged : bool = false
var is_slottable : bool
var original_position : Vector3 = Vector3.ZERO
var original_parent : Node3D
var current_highlight : Node3D

signal dropping(collision)
signal picking_up(collision)


func _ready() -> void:
	actor_reference = get_parent()
	actor_reference.add_to_group("IsDraggable")
	if !check_ray:
		check_ray = actor_reference.check_ray
	if !pickup_height:
		pickup_height = actor_reference.pickup_height
	original_position = actor_reference.global_position
	original_parent = actor_reference.get_parent()
	
	actor_reference.mouse_entered.connect(on_mouse_entered)
	actor_reference.mouse_exited.connect(on_mouse_exited)
	
	call_deferred("_post_ready")


func _post_ready():
	is_slottable = actor_reference.is_in_group("IsSlottable")
	if is_slottable:
		slottable_component = actor_reference.find_child("SlottableNode")
	if debug:
		print(actor_reference.name, " is_slottable:	", is_slottable)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_being_dragged:
		drag(delta)
	if Input.is_action_just_released("pick_up"):
		drop()
	if Input.is_action_just_pressed("pick_up") && BoardManager.current_focus == actor_reference:
		pick_up()
	#if debug:
		#print(actor_reference.name + "'s check_ray is colliding with:	" + str(check_ray.get_collider()))


func pick_up():
	picking_up.emit(check_ray.get_collider())
	is_being_dragged = true
	original_position = actor_reference.global_position
	if actor_reference.get_parent() != original_parent:
		actor_reference.reparent(original_parent)


func drag(delta):
	var current_position = BoardManager.mouse_world_position
	var target_position = Vector3(current_position.x, original_position.y + pickup_height, current_position.z)
	var drag_factor = (actor_reference.global_position - target_position).length() + 1
	actor_reference.global_position = actor_reference.global_position.move_toward(target_position, delta * drag_factor * drag_speed)
	var collider = check_ray.get_collider()
	if collider != null && is_slottable && current_highlight == null:
		if collider is AbstractSlot:
			if debug:
				print(slottable_component.slottable_data.tags)
				print(collider.slot_component.valid_tags)
			if collider.is_valid_slottable(slottable_component.slottable_data.tags):
				current_highlight = collider
				current_highlight.apply_highlight()
				# print("Highlighting:	", current_highlight)
	if !collider is AbstractSlot && current_highlight != null:
		# print("Removing highlight from:	", current_highlight)
		current_highlight.remove_highlight()
		current_highlight = null



func drop():
	var dropping_on = check_ray.get_collider()
	is_being_dragged = false
	var drop_position = check_ray.get_collision_point()
	if !is_slottable:
		if !is_valid_drop():
			actor_reference.global_position = original_position
		else:
			actor_reference.global_position = Vector3(actor_reference.global_position.x, BoardManager.board_height, actor_reference.global_position.z)
			dropping.emit(dropping_on)
	else:
		if dropping_on.is_in_group("HasSlot"):
			if slottable_component.is_valid_drop(dropping_on):
				dropping.emit(dropping_on)
				# print(actor_reference.name + " slotted into " + dropping_on.name)
				actor_reference.reparent(dropping_on)
				actor_reference.global_position = dropping_on.slot_position.global_position
			else:
				# print(dropping_on)
				# print(dropping_on.slot_component.valid_tags)
				actor_reference.global_position = original_position
		else:
			actor_reference.global_position = Vector3(actor_reference.global_position.x, BoardManager.board_height, actor_reference.global_position.z)
	if current_highlight:
		current_highlight.remove_highlight()
		current_highlight = null


func on_mouse_entered():
	if !Input.is_action_pressed("pick_up"):
		BoardManager.current_focus = actor_reference


func on_mouse_exited():
	if BoardManager.current_focus == actor_reference && !Input.is_action_pressed("pick_up"):
		BoardManager.current_focus = null


func is_valid_drop() -> bool:
	var landing_on = check_ray.get_collider()
	if !landing_on:
		return false
	else:
		return true
