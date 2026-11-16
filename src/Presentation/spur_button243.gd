class_name SpurButton243
extends Control

## Juanito's spurs button (Ant 16-nov 21:46, "Implementa y válida todo",
## wamid...Q0ZFNTM5Q0IyMDFCNjI1RTRGNDMwRjI1NzdDQ0UzNAA=). Explicit button -
## no extra joystick gesture - showing stamina cost and cooldown before use.
## Visible only while spurs are equipped; disabled while the rider cannot
## burst (cooldown, exhausted, stunned, jumping, dodging, low stamina).

var player: CharacterBody2D
var _cost_label: Label

func _ready() -> void:
	position = Vector2(956, 636)
	size = Vector2(76, 76)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var bg := Panel.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.add_theme_stylebox_override("panel", RanchTheme.box(Color("1b3d49"), Color("478b9a"), 12))
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	_cost_label = Label.new()
	_cost_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_cost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_cost_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_cost_label.add_theme_font_size_override("font_size", 15)
	_cost_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_cost_label)
	var click := Button.new()
	click.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	click.flat = true
	click.tooltip_text = "Espuelas"
	click.pressed.connect(_pressed)
	add_child(click)

func _pressed() -> void:
	if player != null and is_instance_valid(player) and player.has_method("try_activate_spurs"):
		player.try_activate_spurs()
		_refresh()

func _process(_delta: float) -> void:
	_refresh()

func _refresh() -> void:
	var item: Dictionary = EquipmentEffects.spurs()
	visible = not item.is_empty()
	if not visible: return
	var ready: bool = false
	if player != null and is_instance_valid(player) and player.has_method("try_activate_spurs"):
		ready = player.gait_cap>=WorldGait.GALOPE and player.spurs_world_enabled243 and player.is_physics_processing() and player.movement_wish().length()>.1 and player.spur_cooldown_left <= 0.0 and player.spur_boost_left <= 0.0 \
			and not player.stamina_forced243 and player.stamina_ratio243 >= float(item.get("spur_stamina_cost", 0.15)) \
			and player._stun_time_remaining <= 0.0 and player._jump_time <= 0.0 \
			and (player.dodge == null or (not player.dodge.drawing and player.dodge.remaining <= 0.0 and player.dodge.coast_remaining<=0.0))
	modulate = Color.WHITE if ready else Color(1, 1, 1, 0.45)
	var cost_pct: int = int(round(float(item.get("spur_stamina_cost", 0.15)) * 100.0))
	if player != null and is_instance_valid(player) and player.spur_cooldown_left > 0.0 and player.spur_boost_left <= 0.0:
		_cost_label.text = "%.0f" % ceil(player.spur_cooldown_left)
	elif player != null and is_instance_valid(player) and player.spur_boost_left > 0.0:
		_cost_label.text = "!"
	else:
		_cost_label.text = "Espuelas\n-%d%%" % cost_pct
	queue_redraw()

func _draw() -> void:
	if player == null or not is_instance_valid(player): return
	# Cooldown sweep over the button face.
	if player.spur_cooldown_left > 0.0 and player.spur_boost_left <= 0.0:
		var ratio: float = player.spur_cooldown_ratio()
		draw_arc(size * 0.5, 30.0, -PI * 0.5, -PI * 0.5 + TAU * (1.0 - ratio), 24, Color("f7d58a"), 5.0, true)
	elif player.spur_boost_left > 0.0:
		draw_arc(size * 0.5, 30.0, 0.0, TAU, 24, Color("8ddca8"), 5.0, true)
