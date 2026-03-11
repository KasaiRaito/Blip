extends StaticBody2D
class_name Chest

const COIN_SCENE = preload("uid://dhfw4vmrrtjcu")

@export var coin_max_amount: int = 5
@export var coin_min_amount: int = 2

@onready var chest_closed: Sprite2D = $ChestClosed
@onready var chest_opened: Sprite2D = $ChestOpened
@onready var chest_sound: AudioStreamPlayer = $ChestSound
@onready var drop_pos: Marker2D = $DropPos

var opened: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if opened or not (body is Player):
		return
	
	opened = true
	call_deferred("_open_chest")

func _open_chest() -> void:
	chest_closed.hide()
	chest_opened.show()
	chest_sound.pitch_scale = randf_range(0.75, 1.25)
	chest_sound.volume_db = randf_range(-3, 3)
	chest_sound.play()
	
	var coin_num = randi_range(coin_min_amount, coin_max_amount)
	
	for i in range(coin_num):
		var coin = COIN_SCENE.instantiate() as Coin
		get_tree().root.add_child(coin)
		var pos = drop_pos.global_position
		coin.global_position = Vector2(
			randf_range(pos.x - 20, pos.x + 20),
			pos.y
		)
