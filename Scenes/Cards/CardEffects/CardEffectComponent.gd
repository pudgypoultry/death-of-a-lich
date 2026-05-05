extends Node
class_name CardEffectComponent

var actor_reference : AbstractCard

signal completed


func execute():
	actor_reference = get_parent().actor_reference
	print_debug("	" + actor_reference.name + " used its " + name)
	completed.emit.call_deferred()
