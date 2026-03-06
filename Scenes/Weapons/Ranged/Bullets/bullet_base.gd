extends Area2D
class_name Bullet

var data: WeaponData

func setup(data: WeaponData) -> void:
	self.data = data

func _process(delta: float) -> void:
	if not data:
		return
	move_local_x(data.bullet_speed * delta)

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	
