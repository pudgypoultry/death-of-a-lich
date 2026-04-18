extends Node
class_name SlotComponent

@export var valid_tags : Array[GlobalEnums.CardTags]
@export var debug : bool = false

var actor_reference : Node3D
var currently_slotted_object : Node3D = null
var slot_data : SlottableData = null
var slot_position : Vector3 = Vector3.ZERO
var highlight_component : HighlightComponent
var slot_manager : SlotManager


signal slot_filled(slotted_object)
signal slot_emptied(slotted_object)

var debug_timer = 0.0

func _ready() -> void:
	actor_reference = get_parent()
	actor_reference.add_to_group("HasSlot")
	slot_position = actor_reference.slot_position.global_position
	var highlight = find_children("*", "HighlightNode")
	if len(highlight) > 0:
		highlight_component = highlight[0]


func setup_slot(manager : SlotManager, tags : Array[GlobalEnums.CardTags]):
	slot_manager = manager
	valid_tags = tags
	slot_filled.connect(manager.fill_slot)
	slot_emptied.connect(manager.empty_slot)


func fill_slot(object_to_slot : Node3D) -> bool:
	if is_valid_slottable(object_to_slot.slottable_data.tags):
		slot_filled.emit(object_to_slot)
		currently_slotted_object = object_to_slot
		slot_data = object_to_slot.slottable_data
		return true
	return false


func empty_slot():
	if currently_slotted_object != null:
		slot_emptied.emit(currently_slotted_object)
		currently_slotted_object = null
		slot_data = null
	else:
		if debug:
			print("what the hell happened")


func apply_highlight():
	if highlight_component:
		highlight_component.apply_highlight()


func remove_highlight():
	if highlight_component:
		highlight_component.remove_highlight()


func is_valid_slottable(array):
	for tag in valid_tags:
		if tag in array:
			return true
	return false
