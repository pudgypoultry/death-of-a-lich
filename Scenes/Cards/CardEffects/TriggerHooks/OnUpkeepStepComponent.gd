extends TriggerHookComponent
class_name OnUpkeepStepComponent


func _ready():
	actor_reference.add_to_group("HasUpkeepStepTrigger")
