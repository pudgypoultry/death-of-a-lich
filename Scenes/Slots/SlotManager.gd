extends Node3D
class_name SlotManager

@export var slots : Array[AbstractSlot] = []
@export var slots_contents : Array[AbstractCard] = []
@export var slots_data : Array[SlottableData] = []
@export var valid_tags : Array[GlobalEnums.CardTags]
@export var slot_scene : PackedScene
@export var spawn_position : Node3D


func _ready():
	for slot in slots:
		slot.setup_slot(self, valid_tags)


func spawn_slot():
	var new_slot : AbstractSlot = slot_scene.instantiate()
	add_child(new_slot)
	new_slot.setup_slot(self, valid_tags)
	new_slot.global_position = spawn_position.global_position
	slots.append(new_slot)


func fill_slot(object_to_slot : Node3D):
	print("Slotted:	", object_to_slot)
	print("Slotted card name:	", object_to_slot.slottable_data.card_name)
	slots_contents.append(object_to_slot)
	slots_data.append(object_to_slot.slottable_data)


func empty_slot(object_leaving_slot : Node3D):
	print("Unslotted:	", object_leaving_slot)
	slots_contents.erase(object_leaving_slot)
	slots_data.erase(object_leaving_slot.slottable_data)
