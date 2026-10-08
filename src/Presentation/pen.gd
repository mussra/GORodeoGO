extends Area2D

## Presentation layer: detects a controlled bull entering the safe zone and closes the loop
## (GAMEPLAY_SPEC.md #Cuadra / #Level contract "completion condition").

const ART_PATH: String = "res://art/pen/pen.png"

signal bull_returned(bull: Node2D)

func _ready() -> void:
	collision_mask |= CollisionLayers.BULL_PASSIVE  # held bulls live on this layer (D036)
	body_entered.connect(_on_body_entered)
	_try_swap_sprite()

func _try_swap_sprite() -> void:
	if not ResourceLoader.exists(ART_PATH):
		return
	var texture: Texture2D = load(ART_PATH)
	if texture == null:
		return
	var sprite := Sprite2D.new()
	sprite.texture = texture
	add_child(sprite)
	$Polygon2D.visible = false

func _on_body_entered(body: Node2D) -> void:
	if not ("controller" in body):
		return

	var controller: BullController = body.controller
	if controller == null:
		return

	if controller.current_state() == BullState.State.CONTROLLED:
		if controller.return_to_pen():
			bull_returned.emit(body)
