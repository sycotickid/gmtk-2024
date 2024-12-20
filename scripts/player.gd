extends CharacterBody3D

@onready var anchor = $Anchor
@onready var spring_arm = $Anchor/SpringArm3D
@onready var camera = $Anchor/SpringArm3D/Camera
@onready var block_check = $Anchor/SpringArm3D/Camera/BlockCheck
@onready var crosshair = $Anchor/SpringArm3D/Camera/BlockCheck/Crosshair

@onready var mesh = $Mesh
@onready var girl = $"Mesh/character-female-b2"
@onready var animation_tree = $Mesh/AnimationTree
@onready var animation_state = $Mesh/AnimationTree.get("parameters/playback")

@onready var climb_check = $Mesh/ClimbCheck
@onready var climb_finished_check = $Mesh/ClimbFinishCheck

#CAMERA
const ORBIT_SPEED := 0.002
const PITCH_LIMIT := 60
var _yaw := float()
var _pitch := float()
#MOVEMENT
const SPEED = 5.0
const ROTATION_SPEED = 20.0
const CLIMB_SPEED = 2.5
const JUMP_VELOCITY = 4.5
var direction: Vector3
#ZOOM
const SCROLL_SPEED := 25.0
const ZOOM_MIN := 1.0
const ZOOM_MAX := 15.0
var _scroll_speed := 0.0
#CLIMBING
var can_climb := true
var is_climbing := false
var stamina := 5.0
var last_floor := true

func _ready():
	anchor.basis = basis
	girl.visible = true
	pass

func _process(delta):
	if direction != Vector3.ZERO:
		if !is_climbing:
			mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(direction.x, direction.z), ROTATION_SPEED * delta)
		else:
			stamina = clampf(stamina - 0.05, 0, 10.0)
			mesh.rotation.y = -atan2(climb_check.get_collision_normal().z, climb_check.get_collision_normal().x) - Global.Deg90
	if !is_climbing:
		stamina = clampf(stamina + 0.1, 0, 10.0)
	if stamina <= 0.0:
		is_climbing = false
		can_climb = false
		climb_check.enabled = false
		await get_tree().create_timer(5).timeout
		stamina = 10.0
		can_climb = true
		climb_check.enabled = true
	
	var block = block_check.get_collider()
	if is_instance_valid(block):
		crosshair.set_surface_override_material(0, preload("res://assets/materials/crosshair_hover.tres"))
	else:
		crosshair.set_surface_override_material(0, preload("res://assets/materials/crosshair.tres"))

func _physics_process(delta):
	if Global.current_gamemode != Global.GameMode.SCALE:
		if not is_on_floor():
			velocity += get_gravity() * delta
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		move_and_slide()
		return
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	if can_climb:
		if !Input.is_action_pressed("jump"):
			climbing()
	if is_climbing:
		var wall_normal_rotation = -(atan2(climb_check.get_collision_normal().z, climb_check.get_collision_normal().x) - Global.Deg90)
		if Global.current_gamemode == Global.GameMode.SCALE:
			direction = Vector3(input_dir.x, input_dir.y, 0).rotated(Vector3.UP, wall_normal_rotation).normalized()
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.y = direction.y * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		if Input.is_action_pressed("jump"):
			stop_climbing()
	else:
		if not is_on_floor():
			velocity += get_gravity() * 2 * delta
			
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY * 1.5
			animation_tree.set("parameters/conditions/is_jumping", true)
			animation_tree.set("parameters/conditions/is_grounded", false)
		if is_on_floor() and !last_floor:
			animation_tree.set("parameters/conditions/is_jumping", false)
			animation_tree.set("parameters/conditions/is_grounded", true)
		last_floor = is_on_floor()

		direction = (transform.basis * Vector3(-input_dir.x, 0, input_dir.y)).normalized()
		direction = direction.rotated(Vector3.UP, anchor.rotation.y).normalized()
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		animation_tree.set("parameters/IdleWalkRun/blend_position", velocity.length()/SPEED)
	if Global.current_gamemode == Global.GameMode.SCALE:
		move_and_slide()
	
	if global_position.y <= -5.0:
		global_position = Vector3(0,1.25,0)
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		anchor.rotation.y = lerpf(anchor.rotation.y, _yaw, delta*10)
		anchor.rotation.x = lerpf(anchor.rotation.x, _pitch, delta*10)
		_pitch = clamp(_pitch, deg_to_rad(-PITCH_LIMIT), deg_to_rad(PITCH_LIMIT))
	
	spring_arm.spring_length -= _scroll_speed * 0.5 * delta
	spring_arm.spring_length = clamp(spring_arm.spring_length, -6, -1)
	_scroll_speed = 0.0

func _input(event):
	if Global.current_gamemode != Global.GameMode.SCALE:
		return
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			_yaw += -event.relative.x * ORBIT_SPEED
			_pitch += event.relative.y * ORBIT_SPEED
		
	var scroll_input = Input.get_axis("zoom_in_camera", "zoom_out_camera")
	if scroll_input != 0:
		_scroll_speed = scroll_input * SCROLL_SPEED
		
	if event.is_action_pressed("select"):
		_check_for_block()
	if event.is_action_released("select"):
		animation_tree.set("parameters/conditions/dropped_block", true)
		animation_tree.set("parameters/conditions/is_holding_block", false)

func climbing():
	if climb_check.is_colliding():
		if climb_finished_check.is_colliding():
			await get_tree().create_timer(0.3).timeout
			start_climbing()
		else:
			stop_climbing()
	else:
		stop_climbing()

func start_climbing():
	is_climbing = true
	animation_tree.set("parameters/conditions/is_climbing", true)
	if animation_tree.get("parameters/conditions/is_jumping"):
		animation_tree.set("parameters/conditions/is_jumping", false)

func stop_climbing():
	if is_climbing:
		is_climbing = false
		animation_tree.set("parameters/conditions/is_climbing", false)
		animation_tree["parameters/playback"].travel("IdleWalkRun")

func _check_for_block():
	var block = block_check.get_collider()
	if is_instance_valid(block):
		if !Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			block.call("pick_up_block")
			animation_tree.set("parameters/conditions/dropped_block", false)
			animation_tree.set("parameters/conditions/is_holding_block", true)
