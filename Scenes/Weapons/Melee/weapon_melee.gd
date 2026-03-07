extends Weapon
class_name WeaponMelee

@onready var sprite: Sprite2D = %Sprite2D
@onready var slash_particle: GPUParticles2D = %SlashParticle
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var slash_sfx: AudioStreamPlayer = $SlashSFX
@onready var cooldown: Timer = $Cooldown

var can_use: bool = true
var entities: Array[Node2D]
var direction: Vector2


func _ready() -> void:
	cooldown.wait_time = data.cooldown

func _process(delta: float) -> void:
	rotate_weapon()
	
	if Input.is_action_pressed("Shoot") && can_use:
		use_weapon()

func use_weapon() -> void:
	can_use = false
	cooldown.start()
	slash_sfx.play()
	animation_player.play("Slash")
	
	slash_particle.global_rotation = pivot.global_rotation
	slash_particle.emitting = true
	
	print(entities)
	
	#for other Node2D: entities:

func _on_cooldown_timeout() -> void:
	can_use = true
	animation_player.play("Idle")

func rotate_weapon() -> void:
	direction = get_global_mouse_position() - global_position
	sprite.flip_v = (direction.x < 0)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_instance_valid(body):
		entities.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if is_instance_valid(body):
		entities.erase(body)
