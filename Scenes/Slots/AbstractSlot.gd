extends Area3D
class_name AbstractSlot

@onready var slot_component : SlotComponent = $SlotComponent
@onready var highlight_component : HighlightComponent = $HighlightComponent

@export var slot_position : Node3D

var collider_shape : BoxShape3D
var original_collider_size : Vector3
var filled_collider_size : Vector3


func _ready():
	collider_shape = $CollisionShape3D.shape
	original_collider_size = collider_shape.size
	filled_collider_size = Vector3(original_collider_size.x, 0.01, original_collider_size.z)


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
	collider_shape.size = original_collider_size
	slot_component.empty_slot()


func setup_slot(manager : SlotManager, tags : Array[GlobalEnums.CardTags]):
	slot_component.setup_slot(manager, tags)


func on_enter_hover(card : Node3D):
	if card.is_in_group("IsSlottable"):
		var drag_and_drop_component : DragAndDropComponent = card.drag_and_drop_component
		var slottable_data : SlottableData = card.slottable_data
		drag_and_drop_component.potential_drop = self
		if slot_component.is_valid_slottable(slottable_data.tags):
			drag_and_drop_component.valid_drop = true
		else:
			drag_and_drop_component.valid_drop = false


func on_leave_hover(card : Node3D):
	if card.is_in_group("IsSlottable"):
		var drag_and_drop_component : DragAndDropComponent = card.drag_and_drop_component
		if drag_and_drop_component.potential_drop == self:
			drag_and_drop_component.potential_drop = null
			drag_and_drop_component.valid_drop = false
