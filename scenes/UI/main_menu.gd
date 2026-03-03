extends Control
class_name MainMenu

@export var menu_cursor: Texture2D

@onready var main_buttons: Control = $MainButtons
@onready var settings_buttons: Control = $SettingsButtons
@onready var ui_sound: AudioStreamPlayer = $UI_Sound
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var music_label: Label = %Music_Label
@onready var sfx_label: Label = %SFX_Label
@onready var window_label: Label = %WindowLabel

func _ready() -> void:
	#Auto Load
	Global.load_data()
	Cursor.sprite.texture = menu_cursor
	
	update_audio_bus_mute("SFX", sfx_label, Global.settings.sfx)
	update_audio_bus_mute("Music", music_label, Global.settings.music)
	update_fullscreen(Global.settings.fullscreen)

func update_audio_bus_mute(bus_name: String, label: Label, is_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), !is_on)
	
	label.text = ("%s: %s" % [bus_name, "ON" if is_on else "OFF"])

func update_audio_bus_vol(bus_name: String, label: Label, vol: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(bus_name),vol/100.0)
	label.text = ("%s: %s" % [bus_name, vol])
	
	await get_tree().create_timer(2.0).timeout
	
	if vol == 0:
		update_audio_bus_mute(bus_name, label, false)
	else:
		update_audio_bus_mute(bus_name, label, true)


func update_fullscreen(is_on : bool) -> void:
	var mode =DisplayServer.WINDOW_MODE_FULLSCREEN if is_on else DisplayServer.WindowMode.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
	window_label.text = ("FULLSCREEN" if is_on else "WINDOWED")

"""
Main Menu
"""
func _on_play_button_button_down() -> void:
	ui_sound.play()
	Transition.transition_to("res://Scenes/UI/character_selection.tscn")

func _on_settings_button_pressed() -> void:
	ui_sound.play()
	var tween := create_tween()
	tween.tween_property(main_buttons, "global_position:y", 350.0, 0.2)
	tween.tween_interval(0.1)
	tween.tween_property(settings_buttons, "global_position:x", 145.0, 0.3)


func _on_quit_button_pressed() -> void:
	ui_sound.play()
	Global.save_data()
	get_tree().quit()

"""
Settings
"""
func _on_music_button_pressed() -> void:
	ui_sound.play()
	Global.settings.music = not Global.settings.music
	update_audio_bus_mute("Music", music_label, Global.settings.music)

func _on_sfx_button_pressed() -> void:
	ui_sound.play()
	Global.settings.sfx = not Global.settings.sfx
	update_audio_bus_mute("SFX", sfx_label, Global.settings.sfx)

func _on_window_button_pressed() -> void:
	ui_sound.play()
	Global.settings.fullscreen = not Global.settings.fullscreen
	update_fullscreen(Global.settings.fullscreen)

func _on_back_button_pressed() -> void:
	ui_sound.play()
	Global.save_data()
	var tween := create_tween()
	tween.tween_property(settings_buttons, "global_position:x", 590.0, 0.3)
	tween.tween_interval(0.1)
	tween.tween_property(main_buttons, "global_position:y", 94.0, 0.2)


func _on_music_minus_pressed() -> void:
	ui_sound.play()
	var tempVol = clamp(Global.settings.music_volume - 10 ,0, 100)
	Global.settings.music_volume = tempVol
	update_audio_bus_vol("Music", music_label, Global.settings.music_volume)

func _on_music_plus_pressed() -> void:
	ui_sound.play()
	var tempVol = clamp(Global.settings.music_volume + 10 ,0, 100)
	Global.settings.music_volume = tempVol
	update_audio_bus_vol("Music", music_label, Global.settings.music_volume)

func _on_sfx_minus_pressed() -> void:
	ui_sound.play()
	var tempVol = clamp(Global.settings.sfx_volume - 10 ,0, 100)
	Global.settings.sfx_volume = tempVol
	update_audio_bus_vol("SFX", sfx_label, Global.settings.sfx_volume)

func _on_sfx_plus_pressed() -> void:
	ui_sound.play()
	var tempVol = clamp(Global.settings.sfx_volume + 10 ,0, 100)
	Global.settings.sfx_volume = tempVol
	update_audio_bus_vol("SFX", sfx_label, Global.settings.sfx_volume)

func _notification(what: int) -> void:
	if(what == NOTIFICATION_WM_CLOSE_REQUEST):
		Global.save_data()

func on_button_mouse_entered() -> void:
	hover_sound.play()
