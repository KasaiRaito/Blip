extends CharacterBody2D
class_name Player

@export var data: PlayerData
@onready var visuals: Node2D = $Visuals
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var weapon_controller: WeaponController = $WeaponController
@onready var hurt_sfx: AudioStreamPlayer = $HurtSFX

var can_move = true
var movement: Vector2
var direction: Vector2
var cooldown: float
var hit_material: ShaderMaterial = Global.HIT_MATERIAL.duplicate()
var heal_material: ShaderMaterial = Global.HIT_MATERIAL.duplicate()

@export var max_rewing_time: float
var curretn_rewind_time: float

@export var rewind_frequency: float
var rewind_frame_generation_dt: float
var cur_rewind_frame_generate_dt: float = 0.0

@export var rewind_speed: float

var rewind_values = {
	"position": [],
	"rotation": [],
	"velocity": [],
}

func _ready() -> void:
	curretn_rewind_time = max_rewing_time
	rewind_frame_generation_dt = 1.0/rewind_frequency
	
	print("Frames Size: %s" % rewind_values["position"].size)
	
	print("rewind_dt: %s" %rewind_frame_generation_dt)
	
	health_component.init_health(data.max_hp)
	hit_material.set_shader_parameter("my_custom_color", Color(1, 0, 0))
	heal_material.set_shader_parameter("my_custom_color", Color(0, 0.7, 0))
	
	EventBus.on_player_enter_room.connect(_on_player_enter_room)
	

func _process(delta: float) -> void:
	weapon_controller.target_position = get_global_mouse_position()
	weapon_controller.rotate_weapon()
	
	cooldown -= delta
	
	if Input.is_action_pressed("Shoot") and cooldown <= 0:
		weapon_controller.current_weapon.use_weapon()
		cooldown = weapon_controller.current_weapon.data.cooldown
	
	if Input.is_action_pressed("GoBack"):
		Global.rewinding = true
		
	if Input.is_action_just_released("GoBack"):
		Global.rewinding = false
		Engine.time_scale = 1.0
	
	EventBus.on_player_rewind_change.emit(curretn_rewind_time, max_rewing_time)

func reset_rewind() -> void:
	for key in rewind_values.keys():
		rewind_values[key].clear()

func add_to_rewind(dt: float) -> void:
	cur_rewind_frame_generate_dt -= dt
	
	curretn_rewind_time += dt * 0.5
	
	if cur_rewind_frame_generate_dt <= 0.0:
		if rewind_values["position"].size() == int(rewind_frequency * max_rewing_time):
			for key in rewind_values.keys():
				rewind_values[key].pop_front()
			#print("REMOVE FRAME")
		
		rewind_values["position"].append(global_position)
		rewind_values["rotation"].append(global_rotation)
		rewind_values["velocity"].append(velocity)
		
		cur_rewind_frame_generate_dt = rewind_frame_generation_dt
		#print("ADD FRAME")

func generate_rewind(dt: float) -> void:
	if curretn_rewind_time > 0 and rewind_values["position"].size() > 0:
		Engine.time_scale = 0.25
		
		var temp_dt = rewind_speed / 1.0
		
		curretn_rewind_time -= temp_dt * dt * 2
		
		var pos = rewind_values["position"].pop_back()
		var rot = rewind_values["rotation"].pop_back()
		var vel = rewind_values["velocity"].pop_back()
		
		rotation = rot
		global_position = pos
		velocity = vel
		#print("REWINDING")
		await get_tree().create_timer(temp_dt).timeout
	
	else:
		Global.rewinding = false
		Engine.time_scale = 1.0

func _on_player_enter_room() -> void:
	reset_rewind()

func _physics_process(delta: float) -> void:
	if not can_move:
		return
	
	if not Global.rewinding:
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
		add_to_rewind(delta)
	
	else:
		generate_rewind(delta)
	

func rotate_player() -> void:
	if direction != Vector2.ZERO:
		if direction.x >= 0.1:
			visuals.scale = Vector2(1.25, 1.25)
		else:
			visuals.scale = Vector2(-1.25, 1.25)

func _on_health_component_on_unit_damage(amount: float) -> void:
	Engine.time_scale = 0.5
	EventBus.on_player_health_change.emit(health_component.current_health, data.max_hp)
	
	anim_sprite.material = hit_material
	
	await get_tree().create_timer(0.25).timeout
	anim_sprite.material = null
	Engine.time_scale = 1.0
	
	hurt_sfx.pitch_scale = randf_range(0.75,1.25)
	hurt_sfx.volume_db = randf_range(0, 5)
	hurt_sfx.play()

func _on_health_component_on_unit_dead() -> void:
	can_move = false
	anim_sprite.play("dead")
	await get_tree().create_timer(1.0).timeout
	queue_free()
	EventBus.on_player_death.emit()
	#EventBus.on_player_death.emit()

func _on_health_component_on_unit_heal(amount: float) -> void:
	Engine.time_scale = 0.5
	EventBus.on_player_health_change.emit(health_component.current_health, data.max_hp)
	
	anim_sprite.material = heal_material
	
	await get_tree().create_timer(0.25).timeout
	anim_sprite.material = null
	Engine.time_scale = 1.0

#TEST FUNCTIONS
func _input(event: InputEvent) -> void:
	pass
