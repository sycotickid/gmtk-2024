extends Control

@onready var sfx_player = $SFXPlayer
@onready var control_hint = $ControlHint

var playback: AudioStreamPlaybackPolyphonic

signal block_spawned(name: String)

var is_opened = false

func _ready():
	sfx_player.play()
	playback = sfx_player.get_stream_playback()
	position += Vector2(270, 0)

func _process(delta):
	if Input.is_action_just_pressed("block_menu"):
		playback.play_stream(Global.wood_clacking_sounds.pick_random())
		if is_opened:
			_close_menu()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			_open_menu()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#
func _open_menu():
	control_hint.visible = false
	position = position.lerp(position - Vector2(270,0), 1)
	is_opened = true
	
func _close_menu():
	control_hint.visible = true
	position = position.lerp(position + Vector2(270,0), 1)
	is_opened = false

func _on_square_pressed():
	_call_spawn_block("square")

func _on_rectangle_pressed():
	_call_spawn_block("rectangle")

func _on_triangle_pressed():
	_call_spawn_block("triangle")

func _on_column_pressed():
	_call_spawn_block("column")

func _on_pillar_pressed():
	_call_spawn_block("pillar")

func _on_arch_pressed():
	_call_spawn_block("arch")

func _on_half_circle_pressed():
	_call_spawn_block("half_circle")

func _on_long_triangle_pressed():
	_call_spawn_block("long_triangle")

func _call_spawn_block(index: String):
	playback.play_stream(Global.wood_hit_sounds.pick_random())
	Global.current_gamemode = Global.GameMode.BUILD
	Global.is_carrying_block = true
	block_spawned.emit(index)
	_close_menu()
