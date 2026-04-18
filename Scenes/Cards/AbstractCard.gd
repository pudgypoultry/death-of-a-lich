extends Node3D
class_name AbstractCard

@onready var drag_and_drop_component : DragAndDropComponent = $DragAndDropNode
@onready var slottable_component : SlottableComponent = $SlottableNode

@export var slottable_data : SlottableData
@export var card_faces : Node3D

var flipped : bool = false

# TODO: make front and back faces under same parent, flip that instead
# TODO: create setup function and assign correct mesh to front face and correct script to root node

#func _ready():
	#await get_tree().create_timer(1.5).timeout
	#flip_card()
	#await get_tree().create_timer(1.5).timeout
	#flip_card()


#func setup():
	#front_face.material


func flip_card():
	flipped = !flipped
	card_faces.rotate_z(deg_to_rad(60))
	
