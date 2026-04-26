extends Node
class_name CardEffectComponent

@onready var actor_reference : AbstractCard = get_parent()


func execute():
	print_debug(actor_reference.name + " used its " + name)
