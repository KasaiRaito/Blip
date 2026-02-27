extends Node2D
class_name HealthComponent

signal on_unit_damage(amount: float)
signal on_unit_heal(amount: float)
signal on_unit_dead

var current_health: float
var max_helath: float

func init_health(value: float) -> void:
	current_health = value
	max_helath = value

func take_damage(value: float) -> void:
	if current_health > 0:
		current_health -= abs(value)
		current_health = clamp(current_health , 0.0, max_helath)
		on_unit_damage.emit(abs(value))
		
		if current_health == 0.0:
			die()

func die() -> void:
	on_unit_dead.emit()

func heal(value: float) -> void:
	if current_health >= max_helath:
		return
	
	current_health += abs(value)
	current_health = clamp(current_health , 0.0, max_helath)
	on_unit_heal.emit(value)
