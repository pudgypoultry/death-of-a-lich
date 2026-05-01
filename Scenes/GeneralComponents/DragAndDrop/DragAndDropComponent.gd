extends Node
class_name DragAndDropComponent

@onready var check_ray : RayCast3D = $CheckRay

@export_flags_3d_physics var checkray_layers
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
var potential_drop : Node3D
var valid_drop : bool
var pickup_timer : float = 0.0
var pickup_interval : float = 0.2
var can_pickup : bool = true

signal dropping(collision)
signal picking_up(collision)


func _ready() -> void:
	actor_reference = get_parent()
	actor_reference.add_to_group("IsDraggable")
	if !pickup_height:
		pickup_height = actor_reference.pickup_height
	original_position = actor_reference.global_position
	# print(name, " is trying to assign as parent:	", actor_reference.get_parent())
	original_parent = actor_reference.get_parent()
	actor_reference.set_collision_layer_value(2, true)
	
	call_deferred("_post_ready")


func _post_ready():
	is_slottable = actor_reference.is_in_group("IsSlottable")
	if is_slottable:
		slottable_component = actor_reference.find_child("SlottableNode")
	if debug:
		print(actor_reference.name, " is_slottable:	", is_slottable)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !can_pickup:
		pickup_timer += delta
		if pickup_timer >= pickup_interval:
			can_pickup = true
	
	if is_being_dragged:
		drag(delta)
	if Input.is_action_just_released("pick_up") && is_being_dragged:
		drop()
	if Input.is_action_just_pressed("pick_up") && BoardManager.current_focus == actor_reference:
		pick_up()


func pick_up():
	# print(actor_reference.slottable_data)
	picking_up.emit(check_ray.get_collider())
	if is_slottable:
		highlight_potentials()
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


func drop():
	var drop_position = check_ray.get_collision_point()
	if !is_slottable or (is_slottable && !potential_drop):
		if !is_valid_drop():
			actor_reference.global_position = original_position
		else:
			actor_reference.global_position = Vector3(actor_reference.global_position.x, BoardManager.board_height, actor_reference.global_position.z)
	elif potential_drop && valid_drop:
		dropping.emit(potential_drop)
		print(actor_reference.name + " slotted into " + potential_drop.name)
		actor_reference.reparent(potential_drop)
		actor_reference.global_position = potential_drop.slot_position.global_position
		unhighlight_potentials()
	else:
		actor_reference.global_position = original_position
	BoardManager.current_focus = null
	just_dropped()


func is_valid_drop() -> bool:
	var landing_on = check_ray.get_collider().get_collision_layer() & (checkray_layers)
	if !landing_on:
		return false
	else:
		return true


func highlight_potentials():
	var slots = get_tree().get_nodes_in_group("HasSlot")
	for slot in slots:
		if slot.is_valid_slottable(actor_reference.slottable_data.tags):
			slot.apply_highlight()


func unhighlight_potentials():
	var slots = get_tree().get_nodes_in_group("HasSlot")
	for slot in slots:
		if slot.is_valid_slottable(actor_reference.slottable_data.tags):
			slot.remove_highlight()


func just_dropped():
	pickup_timer = 0.0
	can_pickup = false
	is_being_dragged = false
