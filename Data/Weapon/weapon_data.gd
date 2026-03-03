extends Resource
class_name WeaponData

@export var weapon_name: String
@export var icon: Texture2D
@export var damage: float = 1
@export var cooldown: float = 1
@export var shoot_cost: int = 1
@export var spread: float = 1
@export var bullet_speed: float = 1
@export var bullet_scene: PackedScene
@export_multiline var description: String
