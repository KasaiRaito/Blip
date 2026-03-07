extends Node2D
class_name Arena

@export var arena_curson: Texture2D
@export var level_data: LevelData

@onready var health_bar: TextureProgressBar = %HealthBar
@onready var mana_bar: TextureProgressBar = %ManaBar

var grid: Dictionary[Vector2i, LevelRoom] = {}
var start_room_coord: Vector2i
var end_room_coord: Vector2i

func _ready() -> void:
	#Autoload
	Cursor.sprite.texture = arena_curson
	
	EventBus.on_player_health_change.connect(_on_player_health_change)
	
	generate_level_layout()
	select_special_rooms()
	load_game_selection()
	
func generate_level_layout() -> void:
	grid.clear()
	print("Create layout...")
	
	var current_coord:= Vector2i.ZERO
	grid[current_coord] = null
	var direction: = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	
	while grid.size() < level_data.num_rooms:
		if randf() > 0.5:
			current_coord = grid.keys().pick_random()
		
		var random_direction = direction.pick_random()
		var next_coord = current_coord + random_direction
		
		var attemprs = 0
		while grid.has(next_coord) and attemprs < 10:
			random_direction = direction.pick_random()
			next_coord = current_coord + random_direction
			attemprs += 1
		
		if not grid.has(next_coord):
			grid[next_coord] = null
		
	
	for key: Vector2i in grid.keys():
		print(key)


func select_special_rooms() -> void:
	pass

func load_game_selection() -> void:
	var player: Player = Global.get_player().instantiate()
	add_child(player)
	player.weapon_controller.equip_weapon()

func _on_player_health_change(current_health : float, max_health : float) -> void:
	health_bar.value = (current_health / max_health)
