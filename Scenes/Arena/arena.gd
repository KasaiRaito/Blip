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
	create_rooms()
	#load_game_selection()
	
func generate_level_layout() -> void:
	grid.clear()
	print("Create layout...")
	
	var current_coord:= Vector2i.ZERO
	grid[current_coord] = null
	var directions: = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	
	while grid.size() < level_data.num_rooms:
		if randf() > 0.5:
			current_coord = grid.keys().pick_random()
		
		var random_direction = directions.pick_random()
		var next_coord = current_coord + random_direction
		
		var attemprs = 0
		while grid.has(next_coord) and attemprs < 10:
			random_direction = directions.pick_random()
			next_coord = current_coord + random_direction
			attemprs += 1
		
		if not grid.has(next_coord):
			grid[next_coord] = null
		
	
	for key: Vector2i in grid.keys():
		print(key)

func create_rooms() -> void:
	print("Creating rooms...")
	for room_coord: Vector2i in grid.keys():
		var room_instance: LevelRoom = level_data.room_scene.instantiate()
		room_instance.position = room_coord * level_data.room_size
		add_child(room_instance)
		
		grid[room_coord] = room_instance
		connect_rooms(room_coord, room_instance)
		
		await get_tree().create_timer(0.5).timeout

func connect_rooms(room_coord: Vector2i, room_instance: LevelRoom) -> void:
	var directions: = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	
	for direction in directions:
		var neighbor_coord = room_coord + direction
		if grid.has(neighbor_coord):
			room_instance.open_wall(direction)

func select_special_rooms() -> void:
	start_room_coord = Vector2i.ZERO
	end_room_coord = find_farthest_room()
	
	print("START: %s" % start_room_coord)
	print("END: %s" % end_room_coord)
	

func find_farthest_room() -> Vector2i:
	var farthest_room_coord: Vector2i = start_room_coord
	var max_dist: = 0.0

	for room_coord: Vector2i in grid.keys():
		var dist = start_room_coord.distance_to(room_coord)
		if dist > max_dist:
			max_dist = dist
			farthest_room_coord = room_coord
	
	return farthest_room_coord

func load_game_selection() -> void:
	var player: Player = Global.get_player().instantiate()
	add_child(player)
	player.weapon_controller.equip_weapon()

func _on_player_health_change(current_health : float, max_health : float) -> void:
	health_bar.value = (current_health / max_health)
