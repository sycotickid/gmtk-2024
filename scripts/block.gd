extends RigidBody3D

@onready var rotate_widget = $RotateWidget
@onready var mesh_instance_3d = $MeshInstance3D
@onready var collision_shape_3d = $CollisionShape3D

@onready var sfx_player = $SFXPlayer

@export var preplaced := false

var playback: AudioStreamPlaybackPolyphonic

const OFFSET_MIN := Vector3.UP
const OFFSET_DEF := Vector3.UP * 2.5
const OFFSET_MAX := Vector3.UP * 10.0
const OFFSET_SPEED := 5.0
const DRAG_WEIGHT := 0.2

var is_dragged: bool
var drag_offset := OFFSET_DEF
var offset_amount: float

var camera: Camera3D

func _ready():
	sfx_player.play()
	playback = sfx_player.get_stream_playback()
	camera = get_viewport().get_camera_3d()
	if !preplaced:
		is_dragged = true
		collision_shape_3d.disabled = true
		set_freeze_enabled(true)

func _process(delta):
	if position.y < -5.0:
		queue_free()

func _physics_process(delta):
	if is_dragged:
		mesh_instance_3d.transparency = 0.5
		var mouse_position = Global.screen_to_world_point(camera, get_rid())
		if mouse_position != null:
			drag_offset = clamp(drag_offset + Vector3.UP * offset_amount * delta, OFFSET_MIN, OFFSET_MAX)
			global_transform.origin = mouse_position.get("position") + drag_offset
			offset_amount = 0.0
	else:
		mesh_instance_3d.transparency = 0.0
		collision_shape_3d.disabled = false
		set_freeze_enabled(false)
		drag_offset = OFFSET_DEF

func _input(event):
	if is_dragged:
		if Input.is_action_just_released("select"):
			playback.play_stream(Global.wood_clash_sounds.pick_random())
			Global.current_gamemode = Global.GameMode.SCALE
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			is_dragged = false
			Global.is_carrying_block = false
		
		var offset_input = Input.get_axis("zoom_in_camera", "zoom_out_camera") * OFFSET_SPEED
		if offset_input != 0:
			offset_amount = offset_input
		
		if event.is_action_pressed("reset_transform"):
			playback.play_stream(Global.wood_hit_sounds.pick_random())
			set_rotation(Vector3.ZERO)
		elif event.is_action_pressed("move_left"):
			playback.play_stream(Global.wood_slide_sounds.pick_random())
			rotate_y(-Global.Deg45)
		elif event.is_action_pressed("move_right"):
			playback.play_stream(Global.wood_slide_sounds.pick_random())
			rotate_y(Global.Deg45)
		elif event.is_action_pressed("move_forward"):
			playback.play_stream(Global.wood_slide_sounds.pick_random())
			rotate_x(Global.Deg45)
		elif event.is_action_pressed("move_backward"):
			playback.play_stream(Global.wood_slide_sounds.pick_random())
			rotate_x(-Global.Deg45)

func _on_input_event(camera, event, position, normal, shape_idx):
	if Input.is_action_just_pressed("select") && !Global.is_carrying_block:
		pick_up_block()


func pick_up_block():
	playback.play_stream(Global.wood_hover_sounds.pick_random())
	Global.is_carrying_block = true
	is_dragged = true
	collision_shape_3d.disabled = true
	Global.current_gamemode = Global.GameMode.BUILD
	set_freeze_enabled(true)
