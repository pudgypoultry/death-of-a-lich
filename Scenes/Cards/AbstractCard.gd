extends Node3D
class_name AbstractCard

@onready var drag_and_drop_component : DragAndDropComponent = $DragAndDropNode
@onready var slottable_component : SlottableComponent = $SlottableNode
@onready var card_faces : Node3D = $CardFaces
@onready var original_basis = card_faces.basis
@onready var target_basis = original_basis.rotated(Vector3.LEFT, deg_to_rad(-90))

@export var front_texture_location : String

var flipped : bool = false
var slottable_data : SlottableData

func _ready():
	call_deferred("_post_ready")


func _post_ready():
	var slottable_data : SlottableData = slottable_component.slottable_data
	print(slottable_component)


func rotate_card(time : float, original : Basis, target : Basis):
	card_faces.create_tween().tween_method(interpolate_basis.bind(original, target), 0.0, 1.0, time).set_trans(Tween.TRANS_EXPO)


func interpolate_basis(weight : float, original : Basis, target : Basis):
	card_faces.basis = original.slerp(target, weight)
