extends TextureButton
class_name PlayerCard

@onready var icon: TextureRect = $Icon
@onready var hover_sound: AudioStreamPlayer = $HoverSound

var data: PlayerData

func set_data(value: PlayerData) -> void:
	if not value:
		return
	
	data = value
	icon.texture = data.icon


func _on_mouse_entered() -> void:
	hover_sound.play()
	DampedOscillator.animate(icon, "scale", randf_range(400.0, 450.0), randf_range(5.0, 10.0), randf_range(10.0,15.0), 0.5)
