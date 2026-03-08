extends AnimatedSprite2D
class_name ExplosionEffect

@onready var sfx: AudioStreamPlayer = $SFX

func _ready() -> void:
	sfx.pitch_scale = randf_range(0.75,1.25)
	sfx.volume_db = randf_range(-20,-15)
	sfx.play()

func _on_animation_finished() -> void:
	queue_free()
