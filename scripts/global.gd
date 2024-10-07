extends Node3D

const Deg30 = PI/6
const Deg45 = PI/4
const Deg60 = PI/3
const Deg90 = PI/2

enum GameMode {
	BUILD,
	SCALE
}

@onready var wood_hit_sounds = Array([
	preload("res://assets/sfx/wood_hit_01.mp3"),
	preload("res://assets/sfx/wood_hit_02.mp3"),
	preload("res://assets/sfx/wood_hit_03.mp3"),
	preload("res://assets/sfx/wood_hit_05.mp3"),
	preload("res://assets/sfx/wood_hit_06.mp3"),
	preload("res://assets/sfx/wood_hit_double_01.mp3"),
	preload("res://assets/sfx/wood_hit_double_02.mp3"),
	preload("res://assets/sfx/wood_hit_double_03.mp3"),
	preload("res://assets/sfx/wood_hit_double_04.mp3"),
])

@onready var wood_hover_sounds = Array([
	preload("res://assets/sfx/wood_hover_01.mp3"),
	preload("res://assets/sfx/wood_hover_02.mp3"),
	preload("res://assets/sfx/wood_hover_03.mp3"),
	preload("res://assets/sfx/wood_hover_04.mp3"),
])

@onready var wood_clash_sounds = Array([
	preload("res://assets/sfx/wood_clash_01.mp3"),
	preload("res://assets/sfx/wood_clash_02.mp3"),
	preload("res://assets/sfx/wood_clash_03.mp3"),
	preload("res://assets/sfx/wood_clash_04.mp3"),
])

@onready var wood_clacking_sounds = Array([
	preload("res://assets/sfx/wood_clacking_01.mp3"),
	preload("res://assets/sfx/wood_clacking_02.mp3"),
])

@onready var wood_slide_sounds = Array([
	preload("res://assets/sfx/wood_slide_01.mp3"),
	preload("res://assets/sfx/wood_slide_02.mp3"),
	preload("res://assets/sfx/wood_slide_03.mp3"),
	preload("res://assets/sfx/wood_slide_04.mp3"),
	preload("res://assets/sfx/wood_slide_soft_01.mp3"),
	preload("res://assets/sfx/wood_slide_soft_02.mp3"),
	preload("res://assets/sfx/wood_slide_soft_03.mp3"),
	preload("res://assets/sfx/wood_slide_soft_04.mp3"),
	preload("res://assets/sfx/wood_slide_soft_05.mp3"),
])

var current_gamemode: GameMode
var is_carrying_block := false

func toggle_gamemode():
	if current_gamemode == GameMode.BUILD:
		current_gamemode = GameMode.SCALE
	else:
		current_gamemode = GameMode.BUILD
	return current_gamemode

func screen_to_world_point(camera: Camera3D, excludeRid: RID = RID()):
	var mouse_position = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mouse_position)
	var end = origin + camera.project_ray_normal(mouse_position) * 100
	var query = PhysicsRayQueryParameters3D.create(origin, end, 6, [excludeRid])
	var rayResult = get_world_3d().direct_space_state.intersect_ray(query)
	if !rayResult.is_empty():
		return rayResult
