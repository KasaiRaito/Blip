extends CharacterBody2D
class_name Enemy

@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@onready var player_detector: Area2D = $PlayerDetector
@onready var hurt_sound: AudioStreamPlayer = $HurtSound

var can_move = true
var cached_player: Player

func _physics_process(delta: float) -> void:
	if not Global.player_ref or not can_move:
		return
	
	cached_player = Global.player_ref
	
	var dir := global_position.direction_to(cached_player.global_position)
	velocity = dir * 50.0
	
	move_and_slide()
	rotate_enemy()

func rotate_enemy() -> void:
	if global_position.x > cached_player.global_position.x:
		anim_sprite.flip_h = true
	elif global_position.x < cached_player.global_position.x:
		anim_sprite.flip_h = false


func _on_player_detector_body_entered(body: Node2D) -> void:
	anim_sprite.play("die")
	EventBus.on_enemy_death.emit()
	await anim_sprite.animation_finished
	queue_free()
