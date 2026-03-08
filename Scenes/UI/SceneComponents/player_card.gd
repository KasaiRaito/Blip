extends TextureButton
class_name PlayerCard

@onready var icon: TextureRect = $Icon
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var selector: TextureRect = $Selector
@onready var description_panel: DescriptionPanel = $DescriptionPanel

var data: PlayerData

func set_data(value: PlayerData) -> void:
	if not value:
		return
	
	data = value
	icon.texture = data.icon
	
	set_description()

func set_description() -> void:
	if not data:
		return
	var string: = "Player: %s\nHP: %.0f\nSpeed: %.0f\nShootCount: %.0f" % [data.id,data.max_hp,data.move_speed,data.shoot_count]
	
	description_panel.set_text(string)
	

func _on_mouse_entered() -> void:
	hover_sound.play()
	DampedOscillator.animate(icon, "scale", randf_range(400.0, 450.0), randf_range(5.0, 10.0), randf_range(10.0,15.0), 0.5)
	
	description_panel.show()
	DampedOscillator.animate(description_panel, "scale", randf_range(400.0, 450.0), randf_range(5.0, 10.0), randf_range(5.0,10.0), 0.25)
	DampedOscillator.animate(description_panel, "rotation_degrees", 300.0, 7.5, 15, 0.5 * randf_range(-20.0,20))


func _on_mouse_exited() -> void:
	description_panel.hide()
	pass # Replace with function body.
