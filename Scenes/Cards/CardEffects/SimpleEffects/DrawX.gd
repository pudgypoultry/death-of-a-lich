extends CardEffectComponent
class_name DrawX

@export var num_cards : int = 1

func execute():
	print("DrawX starting, num_cards: ", num_cards)
	for i in num_cards:
		print("DrawX awaiting draw_card ", i)
		await BoardManager.draw_card()
		print("DrawX draw_card ", i, " completed")
	print("DrawX calling super")
	super.execute()
	print("DrawX done")
