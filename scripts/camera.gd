extends Node3D

@onready var camera := $Camera
@onready var block_check = $Camera/BlockCheck

var _mouse_position := Vector3()
#ORBIT
const ORBIT_SPEED := 0.5
var _orbit_speed := Vector2()
#ZOOM
const SCROLL_SPEED := 50.0
const VERTICAL_MIN := 3.0
var _scroll_speed := 0.0
#MOVE
const MOVE_SPEED := 10.0
const MAX_MOVE_DISTANCE := 20.0
var _move_direction := Vector3()

func _physics_process(delta):
	if Global.current_gamemode != Global.GameMode.BUILD:
		return
	
	var mouse_point = Global.screen_to_world_point(camera)
	if mouse_point != null:
		_mouse_position = mouse_point.get("position")
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-_orbit_speed.x * delta)
		camera.rotate_x(-_orbit_speed.y * delta)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
		_orbit_speed = Vector2()
		translate(_move_direction * delta)
		var new_position = position.y + _scroll_speed * delta
		if new_position > VERTICAL_MIN:
			position.y = lerp(position.y, new_position, 0.25)
		_scroll_speed = 0.0

func _input(event):
	if Global.current_gamemode != Global.GameMode.BUILD:
		pass
	else:
		if event is InputEventMouseMotion:
			_orbit_speed = event.relative * ORBIT_SPEED
		
		if !Input.is_action_pressed("select"):
			var scroll_input = Input.get_axis("zoom_in_camera", "zoom_out_camera") * SCROLL_SPEED
			if scroll_input != 0:
				_scroll_speed = scroll_input
			var move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
			_move_direction = Vector3(move_input.x, 0, move_input.y) * MOVE_SPEED
	
