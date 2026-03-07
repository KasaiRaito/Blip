extends Node

var save_path = "user://save.json"
const EXPLOSION_EFFECT_SCENE = preload("uid://y7mpm4d3g4nj")
const DAMAGE_TEXT_SCENE = preload("uid://ckn0qpk2b8hrd")

var settings: Dictionary = {
	"music": true, "music_volume": 10,
	"sfx": true, "sfx_volume": 10,
	"fullscreen": false,
}

var all_players: Dictionary[String, PackedScene] = {
	"Bunny": preload("uid://ca44h6vx2qafq"),
	"Cat": preload("uid://cqpyuvui23hle"),
	"Dog": preload("uid://dj3pml36gc1qc"),
	"Mouse": preload("uid://dtfh5yr33y3ud")
}

var all_weapons: Dictionary[String, PackedScene] = {
	"AK-47": preload("uid://bweeqf142wfbv"),
	"Pistol": preload("uid://clsqrar4g7x3j"),
	"Shotgun": preload("uid://8pfy0oue2gwq"),
	"SMG": preload("uid://q82m3cyofnoq"),
	"Sniper": preload("uid://6yvqnnusp6k6"),
	"Tommy Gun": preload("uid://dvpfuyp81sfxp"),
	"Uzi": preload("uid://btjot64kxelv2"),
	"Axe": preload("uid://5cv2hdbdoe3a"),
	"Sword": preload("uid://dssi24ha6byf5")
}

var selected_player: PlayerData
var selected_weapon: WeaponData

func get_player() -> PackedScene:
	return all_players[selected_player.id]

func get_weapon() -> PackedScene:
	return all_weapons[selected_weapon.weapon_name]

func create_explosion(pos: Vector2) -> void:
	var explosion: Node2D = EXPLOSION_EFFECT_SCENE.instantiate()
	explosion.global_position = pos
	get_tree().root.add_child(explosion)

func create_damage_text(value: int, pos: Vector2) -> void:
	var damage: DamageText = DAMAGE_TEXT_SCENE.instantiate()
	get_parent().add_child(damage)
	var random_pos = randf_range(0, TAU)
	var distance = randf_range(10,25)
	damage.global_position = pos + Vector2.RIGHT.rotated(random_pos) * distance
	
	damage.setup(value)

func save_data() -> void:
	var save = settings.duplicate()
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var json_string = JSON.stringify(save)
	file.store_string(json_string)
	file.close()

func load_data() -> void:
	if not FileAccess.file_exists(save_path):
		return
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	var json = file.get_as_text()
	var data = JSON.parse_string(json)
	file.close()
	
	settings = data
