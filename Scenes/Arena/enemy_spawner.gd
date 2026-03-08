extends Node2D
class_name EnemySpawner

var enemies: Array[Enemy] = []
var enemies_to_kill: int
var have_spawned: bool = false

func _ready() -> void:
	EventBus.on_enemy_death.connect(_on_enemy_death)

func spawn_enemies(data: LevelData, room: LevelRoom) -> void:
	if data.enemy_scenes.is_empty() or have_spawned:
		return
	
	await get_tree().create_timer(0.5).timeout
	
	var amount = randi_range(data.min_enemies_per_room, data.max_enemies_per_room)
	enemies_to_kill += amount
	
	for i in amount:
		var random_scene = data.enemy_scenes.pick_random()
		var enemy: Enemy = random_scene.instantiate()
		enemies.append(enemy)
		get_parent().add_child(enemy)
		var spawn_local_pos = room.get_free_spawn_position()
		var spawn_global_pos = room.to_global(spawn_local_pos)
		
		enemy.global_position = spawn_global_pos
	
	have_spawned = true

func _on_enemy_death() -> void:
	enemies_to_kill -= 1
	
	if enemies_to_kill == 0:
		EventBus.on_room_creared.emit()
		enemies.clear()
		have_spawned = false
	
