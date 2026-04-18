extends StaticBody3D
class_name AbstractSlot

@onready var slot_component : SlotComponent = $SlotComponent
@onready var highlight_component : HighlightComponent = $HighlightComponent

@export var slot_position : Node3D


# Delegating jobs to required components and communicating with slot managers
func is_valid_slottable(array):
	return slot_component.is_valid_slottable(array)


func apply_highlight():
	highlight_component.apply_highlight()


func remove_highlight():
	highlight_component.remove_highlight()


func fill_slot(object_to_slot : Node3D) -> bool:
	return slot_component.fill_slot(object_to_slot)


func empty_slot():
	slot_component.empty_slot()


func setup_slot(manager : SlotManager, tags : Array[GlobalEnums.CardTags]):
	slot_component.setup_slot(manager, tags)
