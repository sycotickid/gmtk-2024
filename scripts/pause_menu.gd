extends Control

@onready var sfx_player = $SFXPlayer

var playback: AudioStreamPlaybackPolyphonic

func _ready():
	sfx_player.play()
	playback = sfx_player.get_stream_playback()

func _on_resume_pressed():
	playback.play_stream(Global.wood_clacking_sounds.pick_random())
	await get_tree().create_timer(0.6).timeout
	hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_restart_pressed():
	playback.play_stream(Global.wood_clacking_sounds.pick_random())
	await get_tree().create_timer(0.6).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	playback.play_stream(Global.wood_clacking_sounds.pick_random())
	await get_tree().create_timer(0.6).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_resume_hovered():
	playback.play_stream(Global.wood_hover_sounds.pick_random())

func _on_main_menu_hovered():
	playback.play_stream(Global.wood_hover_sounds.pick_random())

func _on_restart_hovered():
	playback.play_stream(Global.wood_hover_sounds.pick_random())
