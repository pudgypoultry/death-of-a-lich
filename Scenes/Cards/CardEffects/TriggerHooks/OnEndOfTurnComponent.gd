extends TriggerHookComponent
class_name OnEndOfTurnComponent


func _ready():
	actor_reference.add_to_group("HasOnEndOfTurnTrigger")
