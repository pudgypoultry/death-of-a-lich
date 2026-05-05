extends Node
class_name TriggerHookComponent

@onready var actor_reference : Node3D = get_parent()

@export var effect_queue : Array[CardEffectComponent] = []

signal effect_completed(effect : CardEffectComponent)
signal all_effects_completed

func _ready():
	print("I AM A TRIGGER AN I HAVE:	", actor_reference)


func execute():
	print(actor_reference.name, "executed its triggers:	", effect_queue)
	print("TriggerHook starting, queue length: ", effect_queue.size())
	for effect : CardEffectComponent in effect_queue:
		print("Executing effect: ", effect.name)
		effect.execute()
		print("Awaiting completed from: ", effect.name)
		await effect.completed
		# print_debug(actor_reference.name + " executed effect:	" + effect.name)
		effect_completed.emit(effect)
		print("Got completed from: ", effect.name)
	all_effects_completed.emit()
