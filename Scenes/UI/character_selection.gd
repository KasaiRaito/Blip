extends Control
class_name CharacterSelec

const PLAYER_CARD_SCENE = preload("uid://cxgrn43xe40af")
const WEAPON_CARD_SCENE = preload("uid://bkw36tmg7mc4g")

@export var selection_cursor: Texture2D
@export var players_array: Array[PlayerData]
@export var weapons_array: Array[WeaponData]
@onready var ui_sound: AudioStreamPlayer = $UI_Sound

@onready var player_container: HBoxContainer = $PlayerContainer
@onready var weapon_container: HBoxContainer = $WeaponContainer

func _ready() -> void:
	Cursor.sprite.texture = selection_cursor
	
	load_selection_items()

func load_selection_items() -> void:
	#Make Sure they are empty
	for node in player_container.get_children():
		node.queue_free()
	for node in weapon_container.get_children():
		node.queue_free()
	
	for data in players_array:
		var card: PlayerCard = PLAYER_CARD_SCENE.instantiate()
		player_container.add_child(card)
		card.set_data(data)
	for data in weapons_array:
		var card: WeaponCard = WEAPON_CARD_SCENE.instantiate()
		weapon_container.add_child(card)
		card.set_data(data)


func _on_back_button_button_down() -> void:
	ui_sound.play()
	Transition.transition_to("res://Scenes/UI/main_menu.tscn")
