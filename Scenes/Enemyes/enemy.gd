extends CharacterBody2D
class_name Enemy

@export var max_health: = 5
@export var collision_damage: = 2.0
@export var death_texture: Texture2D 

@export_group("Enemy Chase")
@export var chase_speed: = 40.0

@export_group("Enemy Weapon")
@export var weapon_speed: = 40.0
@export var weapon: WeaponData

@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@onready var player_detector: Area2D = $PlayerDetector
@onready var hurt_sound: AudioStreamPlayer = $HurtSound

@onready var hp_bar: ProgressBar = $HP_Bar
@onready var health_component: HealthComponent = $HealthComponent

var can_move: bool = true
var is_dead: bool = false

var cached_player: Player

func _ready() -> void:
	hp_bar.value = 1.0
	health_component.init_health(max_health)

func _physics_process(_delta: float) -> void:
	if not Global.player_ref or not can_move:
		return
	
	cached_player = Global.player_ref
	
	var dir := global_position.direction_to(cached_player.global_position)
	velocity = dir * chase_speed
	
	move_and_slide()
	rotate_enemy()

func rotate_enemy() -> void:
	if global_position.x > cached_player.global_position.x:
		anim_sprite.flip_h = true
	elif global_position.x < cached_player.global_position.x:
		anim_sprite.flip_h = false

func enemy_death() -> void:
	Global.create_death_particle(death_texture, global_position)
	EventBus.on_enemy_death.emit()
	queue_free()

func _on_player_detector_body_entered(body: Node2D) -> void:
	pass


func _on_health_component_on_unit_damage(amount: float) -> void:
	hp_bar.value = health_component.current_health / max_health
	
	anim_sprite.material = Global.HIT_MATERIAL
	await get_tree().create_timer(0.25).timeout
	anim_sprite.material = null

func _on_health_component_on_unit_dead() -> void:
	enemy_death()
