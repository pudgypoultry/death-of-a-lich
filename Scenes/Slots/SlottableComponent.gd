extends Node
class_name SlottableComponent

@export_category("Necessary Data")
@export var slottable_data : SlottableData
@export var drag_and_drop_node : DragAndDropComponent
@export_category("Debug")
@export var debug : bool = false

var actor_reference : Node3D
var current_slot : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actor_reference = get_parent()
	actor_reference.add_to_group("IsSlottable")
	drag_and_drop_node = actor_reference.find_child("DragAndDropNode")
	if !drag_and_drop_node:
		print("hey big problem bucko")
	drag_and_drop_node.connect("dropping", on_node_dropped)
	drag_and_drop_node.connect("picking_up", on_node_picked_up)
	slottable_data = actor_reference.slottable_data


func on_node_dropped(collider):
	if collider.is_in_group("HasSlot"):
		var slot : SlotComponent = collider.slot_component
		if slot:
			slot.fill_slot(actor_reference)
			current_slot = collider
	if debug:
		for tag in slottable_data.tags:
			var tag_name = GlobalEnums.enum_string(tag, GlobalEnums.CardTags)
			print("	"+tag_name)


func on_node_picked_up(collider):
	#print("Current Slot Before:	", current_slot)
	if current_slot && current_slot == collider:
		current_slot.slot_component.empty_slot()
		current_slot = null
	#print("Current Slot After:	", current_slot)


func is_valid_drop(slot : Node3D) -> bool:
	if slot.is_in_group("HasSlot"):
		var potential_slot : SlotComponent = slot.slot_component
		if potential_slot != null:
			var can_slot = potential_slot.is_valid_slottable(slottable_data.tags)
			return can_slot
	return false
