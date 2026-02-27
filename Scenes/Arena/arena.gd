extends Node2D
class_name Arena
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var mana_bar: TextureProgressBar = %ManaBar

func _ready() -> void:
	EventBus.on_player_health_change.connect(_on_player_health_change)
	#EventBus.on_player_death.connect(_on_plauer_death)

func _on_player_health_change(current_health : float, max_health : float) -> void:
	health_bar.value = (current_health / max_health)
