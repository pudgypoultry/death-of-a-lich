extends Node
class_name CardEffectComponent

@onready var actor_reference : AbstractCard = get_parent()

signal completed

func execute():
	print_debug("	" + actor_reference.name + " used its " + name)
	completed.emit()
