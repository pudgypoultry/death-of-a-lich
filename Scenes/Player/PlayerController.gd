extends Camera3D

@export var ray_length : float = 30.0
@export var max_distance : float = 0.0
@export var min_distance : float = 1.0
@export var camera_move_speed = 0.1

var current_position : Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BoardManager.camera = self


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_pos := get_viewport().get_mouse_position()
		var query := PhysicsRayQueryParameters3D.create(
			project_ray_origin(mouse_pos),
			project_ray_origin(mouse_pos) + project_ray_normal(mouse_pos) * ray_length,
			2
		)
		var result := get_world_3d().direct_space_state.intersect_ray(query)
		if "position" in result.keys():
			BoardManager.mouse_world_position = result["position"]


func _process(delta):
	# camera rotation and reset
	var left_right = Input.get_axis("move_left", "move_right")
	var up_down = Input.get_axis("move_down", "move_up")
	
	if left_right != 0:
		translate_object_local(camera_move_speed * Vector3(left_right,0,0))
	if up_down != 0:
		position += camera_move_speed * -up_down * Vector3(transform.basis.z.x, 0, transform.basis.z.z).normalized()
