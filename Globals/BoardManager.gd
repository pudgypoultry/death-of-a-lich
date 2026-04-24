extends Node

var mouse_ray : RayCast3D
var mouse_world_position : Vector3 = Vector3.ZERO
var camera : Camera3D
var ray_length : float = 30.0
var board_height : float = 0.5
var current_focus : Node3D
var last_focus : Node3D
var can_change_focus : bool = true
var focus_timer : float = 0.2
var time_since_focus_change : float = 0.0
