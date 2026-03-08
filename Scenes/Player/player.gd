extends CharacterBody2D
class_name Player

@export var data: PlayerData
@onready var visuals: Node2D = $Visuals
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var weapon_controller: WeaponController = $WeaponController

var can_move = true
var movement: Vector2
var direction: Vector2

func _ready() -> void:
	health_component.init_health(data.max_hp)

func _physics_process(delta: float) -> void:
	if not can_move:
		return
	
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		movement = direction * data.move_speed
		anim_sprite.play("move")
	else:
		movement = Vector2.ZERO
		anim_sprite.play("idle")
	
	velocity = movement
	move_and_slide()
	rotate_player()

func rotate_player() -> void:
	if direction != Vector2.ZERO:
		if direction.x >= 0.1:
			visuals.scale = Vector2(1.25, 1.25)
		else:
			visuals.scale = Vector2(-1.25, 1.25)

func _on_health_component_on_unit_damage(amount: float) -> void:
	EventBus.on_player_health_change.emit(health_component.current_health, data.max_hp)


func _on_health_component_on_unit_dead() -> void:
	can_move = false
	anim_sprite.play("dead")
	await get_tree().create_timer(1.0).timeout
	queue_free()
	#EventBus.on_player_death.emit()

func _on_health_component_on_unit_heal(amount: float) -> void:
	pass

#TEST FUNCTIONS
func _input(event: InputEvent) -> void:
	pass
