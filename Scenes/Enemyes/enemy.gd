extends CharacterBody2D
class_name Enemy

@export_enum("Chase", "Weapon") var enemy_type = "Chase"

enum EnemyStates{
	FINDING_DESTINATION,
	MOVING,
	ATTACKING 
}

@export var max_health: = 5
@export var collision_damage: = 2.0
@export var death_texture: Texture2D 

@export_group("Enemy Chase")
@export var chase_speed: = 60.0

@export_group("Enemy Weapon")
@export var move_speed: = 40.0
@export var weapon: WeaponData

@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@onready var player_detector: Area2D = $PlayerDetector
@onready var hurt_sound: AudioStreamPlayer = $HurtSound

@onready var hp_bar: ProgressBar = $HP_Bar
@onready var health_component: HealthComponent = $HealthComponent
@onready var enemy_detector: Area2D = $EnemyDetector
@onready var weapon_controller: WeaponController = $WeaponController

var can_move: bool = true
var is_dead: bool = false
var cooldown: float

var cached_player: Player

var parrent_room: LevelRoom
var enemy_state: EnemyStates
var move_destination: Vector2

func _ready() -> void:
	hp_bar.value = 1.0
	health_component.init_health(max_health)
	
	if not weapon or not weapon_controller: 
		return
	
	weapon_controller.equip_weapon(weapon)

func _process(delta: float) -> void:
	if not Global.player_ref:
		return
	
	rotate_enemy()
	
	if enemy_state == EnemyStates.ATTACKING:
		manage_weapon(delta)

func _physics_process(_delta: float) -> void:
	if not Global.player_ref or not can_move:
		return
	
	cached_player = Global.player_ref
	
	match enemy_type:
		"Chase":
			run_enemy_chase()
		"Weapon":
			run_enemy_weapon()

func run_enemy_chase()-> void:
	var dir := global_position.direction_to(cached_player.global_position)
	
	for enemy : Enemy in enemy_detector.get_overlapping_bodies():
		if enemy != self and enemy.is_inside_tree():
			var vector = global_position - enemy.global_position
			dir += 10 * vector.normalized() / vector.length()
	
	velocity = dir * chase_speed
	
	move_and_slide()

func run_enemy_weapon()-> void:
	match enemy_state:
		EnemyStates.FINDING_DESTINATION:
			var local_position = parrent_room.get_free_spawn_position()
			move_destination = parrent_room.to_global(local_position)
			enemy_state = EnemyStates.MOVING
		
		EnemyStates.MOVING:
			var dir = global_position.direction_to(move_destination)
			velocity = dir * move_speed
			move_and_slide()
			
			if global_position.distance_to(move_destination) < 2.0:
				velocity = Vector2.ZERO
				enemy_state = EnemyStates.ATTACKING
		
		EnemyStates.ATTACKING:
			velocity = Vector2.ZERO
			move_and_slide()
			await get_tree().create_timer(1.0).timeout
			enemy_state = EnemyStates.FINDING_DESTINATION

func manage_weapon(delta: float) -> void:
	if not weapon or not weapon_controller: 
		return
	
	weapon_controller.target_position = cached_player.global_position
	weapon_controller.rotate_weapon()
	
	cooldown -= delta
	
	if cooldown <= 0.0:
		weapon_controller.current_weapon.use_weapon()
		cooldown = weapon_controller.current_weapon.data.cooldown

func rotate_enemy() -> void:
	if global_position.x > cached_player.global_position.x:
		anim_sprite.flip_h = true
	elif global_position.x < cached_player.global_position.x:
		anim_sprite.flip_h = false

func enemy_death() -> void:
	if is_dead:
		return
	
	is_dead = true
	Global.create_death_particle(death_texture, global_position)
	EventBus.on_enemy_death.emit()
	queue_free()

func _on_player_detector_body_entered(body: Node2D) -> void:
	body.health_component.take_damage(collision_damage)


func _on_health_component_on_unit_damage(amount: float) -> void:
	hp_bar.value = health_component.current_health / max_health
	
	anim_sprite.material = Global.HIT_MATERIAL
	await get_tree().create_timer(0.25).timeout
	anim_sprite.material = null

func _on_health_component_on_unit_dead() -> void:
	enemy_death()
