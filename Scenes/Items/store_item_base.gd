extends Area2D
class_name StoreItem

@export var common_glow: Color
@export var rare_glow: Color
@export var epic_glow: Color


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var glow: Sprite2D = $Glow
@onready var price: RichTextLabel = $Price

var data: ItemData
var can_buy_item: bool

func set_up(item_data: ItemData) -> void:
	data = item_data
	sprite_2d.texture = data.icon
	glow.self_modulate = get_rarity_color()
	price.text = "[code][img=10]assets/TopDownAssets/Sprites/coin.png[/img] [/code]$%s" % data.price

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") && can_buy_item:
		buy_item()

func buy_item() -> void:
	if not data:
		return
	
	#
	# Add Items To Buy
	#
	match data.id:
		"Potion":
			Global.player_ref.health_component.heal(data.value)
	
	queue_free()

func get_rarity_color()-> Color:
	match data.rarity:
		"Common":
			return common_glow
		"Rare":
			return rare_glow
		"Epic":
			return epic_glow
	
	return Color.RED

func _on_body_entered(body: Node2D) -> void:
	can_buy_item = true

func _on_body_exited(body: Node2D) -> void:
	can_buy_item = false
