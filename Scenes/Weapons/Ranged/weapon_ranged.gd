extends Weapon
class_name WeaponRange

@onready var sprite: Sprite2D = %Sprite2D
@onready var fire_position: Marker2D = %FirePosition

var direction: Vector2
var cooldown: float 

func _process(delta: float) -> void:
	rotate_weapon()

func use_weapon() -> void:
	if not data.bullet_scene:
		return
	
	var bullet: Bullet = data.bullet_scene.instantiate()
	bullet.global_position = fire_position.global_position
	bullet.global_rotation = (fire_position.global_rotation + deg_to_rad(randf_range(-data.spread, data.spread)))
	bullet.setup(data)
	get_tree().root.add_child(bullet)
	cooldown = data.cooldown

func rotate_weapon() -> void:
	direction = get_global_mouse_position() - global_position
	sprite.flip_v = (direction.x < 0)
