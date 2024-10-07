extends Control

@onready var sfx_player = $SFXPlayer

var playback: AudioStreamPlaybackPolyphonic

signal next_level_pressed

func _ready():
	sfx_player.play()
	playback = sfx_player.get_stream_playback()

func _on_next_level_pressed():
	playback.play_stream(Global.wood_clacking_sounds.pick_random())
	await get_tree().create_timer(0.6).timeout
	next_level_pressed.emit()

func _on_main_menu_pressed():
	playback.play_stream(Global.wood_clacking_sounds.pick_random())
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_next_level_hover():
	playback.play_stream(Global.wood_hover_sounds.pick_random())

func _on_main_menu_hovered():
	playback.play_stream(Global.wood_hover_sounds.pick_random())
