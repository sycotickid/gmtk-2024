extends Node3D

@export var next_level: PackedScene
@onready var goal_screen = $"GoalScreen"
@onready var sfx_player = $SFXPlayer
var playback: AudioStreamPlaybackPolyphonic

var goal_reached := false

func _ready():
	sfx_player.play()
	playback = sfx_player.get_stream_playback()
	goal_screen.visible = false
	goal_screen.next_level_pressed.connect(_open_next_level)

func _on_goal_body_entered(body):
	if body is CharacterBody3D && !goal_reached:
		goal_reached = true
		goal_screen.visible = true
		playback.play_stream(preload("res://assets/music/goal_screen.mp3"))
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _open_next_level():
	get_tree().change_scene_to_packed(next_level)
