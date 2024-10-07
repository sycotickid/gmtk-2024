extends Control

@onready var sfx_player = $SFXPlayer
@onready var menu_items = $MarginContainer/VBoxContainer2/MarginContainer/MenuItems
@onready var level_select = $MarginContainer/VBoxContainer2/MarginContainer/LevelSelect

var playback: AudioStreamPlaybackPolyphonic

func _ready():
	level_select.visible = false
	menu_items.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	sfx_player.play()
	playback = sfx_player.get_stream_playback()

#MAIN MENU
func _on_play_pressed():
	playback.play_stream(Global.wood_clacking_sounds.pick_random())
	menu_items.visible = false
	level_select.visible = true

func _on_playground_pressed():
	playback.play_stream(Global.wood_clacking_sounds.pick_random())
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/levels/playground.tscn")

func _on_quit_pressed():
	playback.play_stream(Global.wood_clacking_sounds.pick_random())
	await get_tree().create_timer(0.6).timeout
	get_tree().quit()

#LEVEL SELECT
func _on_lvl_01_pressed():
	playback.play_stream(Global.wood_clacking_sounds.pick_random())
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/levels/level_one.tscn")

func _on_lvl_02_pressed():
	playback.play_stream(Global.wood_clacking_sounds.pick_random())
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/levels/level_two.tscn")

func _on_lvl_03_pressed():
	playback.play_stream(Global.wood_clacking_sounds.pick_random())
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/levels/level_three.tscn")

func _on_lvl_04_pressed():
	playback.play_stream(Global.wood_clacking_sounds.pick_random())
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/levels/level_four.tscn")

func _on_lvl_05_pressed():
	playback.play_stream(Global.wood_clacking_sounds.pick_random())
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/levels/level_five.tscn")
	
func _on_lvl_06_pressed():
	playback.play_stream(Global.wood_clacking_sounds.pick_random())
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/levels/level_six.tscn")

func _on_play_hovered():
	playback.play_stream(Global.wood_hover_sounds.pick_random())

func _on_playground_hovered():
	playback.play_stream(Global.wood_hover_sounds.pick_random())

func _on_quit_hovered():
	playback.play_stream(Global.wood_hover_sounds.pick_random())

func _on_lvl_01_hovered():
	playback.play_stream(Global.wood_hover_sounds.pick_random())

func _on_lvl_02_hovered():
	playback.play_stream(Global.wood_hover_sounds.pick_random())

func _on_lvl_03_hovered():
	playback.play_stream(Global.wood_hover_sounds.pick_random())

func _on_lvl_04_hovered():
	playback.play_stream(Global.wood_hover_sounds.pick_random())

func _on_lvl_05_hovered():
	playback.play_stream(Global.wood_hover_sounds.pick_random())

func _on_lvl_06_hovered():
	playback.play_stream(Global.wood_hover_sounds.pick_random())
