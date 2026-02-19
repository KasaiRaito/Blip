extends Control
class_name MainMenu

@onready var main_buttons: Control = $MainButtons
@onready var settings_buttons: Control = $SettingsButtons
@onready var ui_sound: AudioStreamPlayer = $UI_Sound
@onready var music_label: Label = %Music_Label
@onready var sfx_label: Label = %SFX_Label
@onready var window_label: Label = %WindowLabel

func _ready() -> void:
	Global.load_data();
	update_audio_bus_mute("SFX", sfx_label, Global.settings.sfx);
	update_audio_bus_mute("Music", music_label, Global.settings.music);
	update_fullscreen(Global.settings.fullscreen);

func update_audio_bus_mute(bus_name: String, label: Label, is_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), !is_on);
	label.text = ("%s: %s" % [bus_name, "ON" if is_on else "OFF"]);

func update_fullscreen(is_on : bool) -> void:
	var mode =DisplayServer.WINDOW_MODE_FULLSCREEN if is_on else DisplayServer.WindowMode.WINDOW_MODE_WINDOWED;
	DisplayServer.window_set_mode(mode)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE);
	window_label.text = ("FULLSCREEN" if is_on else "WINDOWED")

"""
Main Menu
"""
func _on_play_button_pressed() -> void:
	ui_sound.play();
	Transition.trnsition_to("res://Scenes/UI/character_selection.tscn")


func _on_settings_button_pressed() -> void:
	ui_sound.play();
	var tween := create_tween();
	tween.tween_property(main_buttons, "global_position:y", 350.0, 0.2);
	tween.tween_interval(0.1);
	tween.tween_property(settings_buttons, "global_position:x", 145.0, 0.3);


func _on_quit_button_pressed() -> void:
	ui_sound.play();
	Global.save_data();
	get_tree().quit();

"""
Settings
"""
func _on_music_button_pressed() -> void:
	ui_sound.play();
	Global.settings.music = not Global.settings.music;
	update_audio_bus_mute("Music", music_label, Global.settings.music);

func _on_sfx_button_pressed() -> void:
	ui_sound.play();
	Global.settings.sfx = not Global.settings.sfx;
	update_audio_bus_mute("SFX", sfx_label, Global.settings.sfx);

func _on_window_button_pressed() -> void:
	ui_sound.play();
	Global.settings.fullscreen = not Global.settings.fullscreen;
	update_fullscreen(Global.settings.fullscreen)

func _on_back_button_pressed() -> void:
	ui_sound.play();
	var tween := create_tween();
	tween.tween_property(settings_buttons, "global_position:x", 590.0, 0.3);
	tween.tween_interval(0.1);
	tween.tween_property(main_buttons, "global_position:y", 94.0, 0.2);


func _on_music_minus_pressed() -> void:
	ui_sound.play();

func _on_music_plus_pressed() -> void:
	ui_sound.play();

func _on_sfx_minus_pressed() -> void:
	ui_sound.play();

func _on_sfx_plus_pressed() -> void:
	ui_sound.play();

func _notification(what: int) -> void:
	if(what == NOTIFICATION_WM_CLOSE_REQUEST):
		Global.save_data();
