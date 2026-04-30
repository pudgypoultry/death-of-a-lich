extends Node
class_name TriggerHookComponent

@onready var actor_reference : Node3D = get_parent()

@export var effect_queue : Array[CardEffectComponent] = []

signal effect_completed(effect : CardEffectComponent)
signal all_effects_completed


func execute():
	for effect : CardEffectComponent in effect_queue:
		effect.execute()
		await effect.completed
		print_debug(actor_reference.name + " executed effect:	" + effect.name)
		effect_completed.emit(effect)
	all_effects_completed.emit()
