extends Node3D

@onready var blocks = {
	"square": preload("res://scenes/blocks/square.tscn"),
	"rectangle": preload("res://scenes/blocks/rectangle.tscn"),
	"triangle": preload("res://scenes/blocks/triangle.tscn"),
	"column": preload("res://scenes/blocks/column.tscn"),
	"pillar": preload("res://scenes/blocks/pillar.tscn"),
	"arch": preload("res://scenes/blocks/arch.tscn"),
	"half_circle": preload("res://scenes/blocks/half_circle.tscn"),
	"long_triangle": preload("res://scenes/blocks/long_triangle.tscn"),
}

@onready var player := $Player
@onready var ui := $UI
@onready var goal = $Goal
@onready var pause_menu = $PauseMenu

var goal_index = 0

var camera: Camera3D
var playerCamera: Camera3D

const camera_offset_radius := 10.0

func _ready():
	camera = get_viewport().get_camera_3d()
	playerCamera = player.get_child(0).get_child(0).get_child(0)
	Global.current_gamemode = Global.GameMode.SCALE
	player.set_process(true)
	playerCamera.current = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	ui.block_spawned.connect(spawn_block)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		pause_menu.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true

func spawn_block(index: String):
	var new_block = blocks[index].instantiate()
	new_block.global_transform = new_block.transform.looking_at(camera.global_position, Vector3.UP).rotated_local(Vector3.UP, Global.Deg90)
	new_block.rotation.y = snapped(new_block.rotation.y, Global.Deg45)
	new_block.rotation.z = 0.0
	new_block.global_transform.origin = player.global_transform.origin + Vector3.UP * 2.5 + Vector3.MODEL_FRONT * 2.5
	add_child(new_block)
