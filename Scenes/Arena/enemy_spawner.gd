extends Node2D
class_name EnemySpawner

@export var arena: Arena

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
	
	print("EnemyCount: %s" % amount)
	
	have_spawned = true
	
	for i in amount:
		var spawn_local_pos = room.get_free_spawn_position()
		var spawn_global_pos = room.to_global(spawn_local_pos)
		
		var marker = Global.SPAWN_MARKER_SCENE.instantiate()
		marker.global_position = spawn_global_pos
		
		get_parent().add_child(marker)
		
		await marker.get_child(0).animation_finished
		
		var random_scene = data.enemy_scenes.pick_random()
		var enemy: Enemy = random_scene.instantiate()
		enemies.append(enemy)
		enemy.parrent_room = arena.current_room
		get_parent().add_child(enemy)
		enemy.global_position = spawn_global_pos
	

func _on_enemy_death() -> void:
	enemies_to_kill -= 1
	
	if enemies_to_kill == 0:
		EventBus.on_room_creared.emit()
		enemies.clear()
		have_spawned = false
	
