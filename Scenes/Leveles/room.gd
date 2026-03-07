extends Node2D
class_name LevelRoom

@onready var room_walls: Dictionary[Vector2i, TileMapLayer] = {
	Vector2i.UP: %WallUP,
	Vector2i.DOWN: %WallDOWN,
	Vector2i.LEFT: %WallLEFT,
	Vector2i.RIGHT: %WallRIGHT
}

func _ready() -> void:
	close_all_walls()
	
	pass

func open_wall(direction: Vector2i) -> void:
	if room_walls.has(direction):
		room_walls[direction].enabled = false

func close_all_walls()-> void:
	for key in room_walls:
		room_walls[key].enabled = true
