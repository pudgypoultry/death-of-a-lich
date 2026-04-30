extends CardEffectComponent
class_name DrawX

@export var num_cards : int = 1

func execute():
	for i in num_cards:
		await BoardManager.draw_card()
	super.execute()
