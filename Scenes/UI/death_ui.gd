extends Control
class_name DeathUI

@export var menu_cursor: Texture2D

@onready var ui_sound: AudioStreamPlayer = $UI_Sound
@onready var hover_sound: AudioStreamPlayer = $HoverSound

func _ready() -> void:
	#Auto Load
	Global.load_data()
	Cursor.sprite.texture = menu_cursor

func _on_quit_button_pressed() -> void:
	ui_sound.play()
	Global.save_data()
	get_tree().quit()

func _on_play_button_mouse_entered() -> void:
	hover_sound.pitch_scale = randf_range(0.75,1.25)
	hover_sound.volume_db = randf_range(-1,1)
	hover_sound.play()

func _on_quit_button_mouse_entered() -> void:
	hover_sound.pitch_scale = randf_range(0.75,1.25)
	hover_sound.volume_db = randf_range(-1,1)
	hover_sound.play()

func _on_retry_button_pressed() -> void:
	ui_sound.play()
	if Global.selected_player and Global.selected_weapon :
		Transition.transition_to("res://Scenes/Arena/arena.tscn")

func _on_change_hero_button_pressed() -> void:
	ui_sound.play()
	Transition.transition_to("res://Scenes/UI/character_selection.tscn")
