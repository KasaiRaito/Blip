extends Control
class_name CharacterSelec

const PLAYER_CARD_SCENE = preload("uid://cxgrn43xe40af")
const WEAPON_CARD_SCENE = preload("uid://bkw36tmg7mc4g")

@export var selection_cursor: Texture2D
@export var players_array: Array[PlayerData]
@export var weapons_array: Array[WeaponData]
@onready var ui_sound: AudioStreamPlayer = $UI_Sound
@onready var hover_sound: AudioStreamPlayer = $HoverSound

@onready var player_container: HBoxContainer = $PlayerContainer
@onready var weapon_container: HBoxContainer = $WeaponContainer

func _ready() -> void:
	Cursor.sprite.texture = selection_cursor
	load_selection_items()
	check_default_selection()

func load_selection_items() -> void:
	#Make Sure they are empty
	for node in player_container.get_children():
		node.queue_free()
	for node in weapon_container.get_children():
		node.queue_free()
	
	for data in players_array:
		var card: PlayerCard = PLAYER_CARD_SCENE.instantiate()
		#Bind
		card.pressed.connect(_on_player_card_pressed.bind(data, card))
		player_container.add_child(card)
		card.set_data(data)
	for data in weapons_array:
		var card: WeaponCard = WEAPON_CARD_SCENE.instantiate()
		#Bind
		card.pressed.connect(_on_weapon_card_pressed.bind(data, card))
		weapon_container.add_child(card)
		card.set_data(data)

func check_default_selection() -> void:
	if not Global.selected_weapon:
		var card: WeaponCard = weapon_container.get_child(0)
		Global.selected_weapon = card.data
		card.selector.show()
	else:
		for card: WeaponCard in weapon_container.get_children():
			if card.data == Global.selected_weapon:
				card.selector.show()
	
	if not Global.selected_player:
		var card: PlayerCard = player_container.get_child(0)
		Global.selected_player = card.data
		card.selector.show()
	else:
		for card: PlayerCard in player_container.get_children():
			if card.data == Global.selected_player:
				card.selector.show()

func _on_play_button_pressed() -> void:
	ui_sound.play()
	if Global.selected_player and Global.selected_weapon :
		Transition.transition_to("res://Scenes/Arena/arena.tscn")

func _on_back_button_button_down() -> void:
	ui_sound.play()
	Transition.transition_to("res://Scenes/UI/main_menu.tscn")

func _on_player_card_pressed(data: PlayerData, selected_card: PlayerCard) -> void:
	ui_sound.play()
	Global.selected_player = data
	
	for card: PlayerCard in player_container.get_children():
		if card != selected_card:
			card.selector.hide()
		else:
			card.selector.show()

func _on_weapon_card_pressed(data: WeaponData, selected_card: WeaponCard) -> void:
	ui_sound.play()
	Global.selected_weapon = data
	
	for card: WeaponCard in weapon_container.get_children():
		if card != selected_card:
			card.selector.hide()
		else:
			card.selector.show()

func _on_play_button_mouse_entered() -> void:
	hover_sound.pitch_scale = randf_range(0.75,1.25)
	hover_sound.volume_db = randf_range(-1,1)
	hover_sound.play()

func _on_back_button_mouse_entered() -> void:
	
	hover_sound.pitch_scale = randf_range(0.75,1.25)
	hover_sound.volume_db = randf_range(-1,1)
	hover_sound.play()
