extends Node3D
class_name DeckVisual

@onready var deck_reference : Deck = get_parent()

@export var card_image : PackedScene
@export var max_deck_size : int = 20

var card_meshes : Array[MeshInstance3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_deck_visual()
	#await get_tree().create_timer(1.0).timeout
	#shuffle_animation()
	


func update_deck_visual():
	var current_deck_size = len(deck_reference.cards)
	for mesh in card_meshes:
		mesh.queue_free()
	if current_deck_size <= max_deck_size:
		for i in range(current_deck_size):
			card_meshes.append(card_image.instantiate())
	else:
		for i in range(max_deck_size):
			card_meshes.append(card_image.instantiate())


func shuffle_animation():
	for mesh in card_meshes:
		var random_direction = [1, -1].pick_random()
		var random_angle = random_direction * ([1, 3, 5, 7, 9].pick_random()) * deg_to_rad(180.0)
		var original_basis = mesh.basis
		var target_basis = original_basis.rotated(Vector3.UP, random_angle)
		var random_transition_type = [
			Tween.TRANS_EXPO, 
			Tween.TRANS_BOUNCE, 
			Tween.TRANS_SINE, 
			Tween.TRANS_SPRING,
			Tween.TRANS_ELASTIC,
			Tween.TRANS_BACK
		].pick_random()
		mesh.create_tween().tween_method(
			shuffle_rotate.bind(original_basis, target_basis, mesh), 
			0.0, 1.0, 0.3).set_trans(random_transition_type)
	

func shuffle_rotate(weight : float, original : Basis, target : Basis, mesh : MeshInstance3D):
	mesh.basis = original.slerp(target, weight)
