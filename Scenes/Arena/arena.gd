extends Node2D
class_name Arena

@export var arena_curson: Texture2D

@onready var health_bar: TextureProgressBar = %HealthBar
@onready var mana_bar: TextureProgressBar = %ManaBar

func _ready() -> void:
	#Autoload
	Cursor.sprite.texture = arena_curson
	
	EventBus.on_player_health_change.connect(_on_player_health_change)
	#EventBus.on_player_death.connect(_on_plauer_death)
	load_game_selection()

func load_game_selection() -> void:
	var player = Global.get_player().instantiate()
	add_child(player)

func _on_player_health_change(current_health : float, max_health : float) -> void:
	health_bar.value = (current_health / max_health)
