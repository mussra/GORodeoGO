class_name PenDoor
extends Area2D

## Presentation layer: a pen-puzzle door (GAMEPLAY_SPEC.md, levels 11+). Opens the bulls
## in its pen once the player stands still next to it for hold_seconds. Spawned at runtime
## by Level0 from LevelData.pens, the same way obstacles are spawned from obstacle_rects —
## no scene node needed.
##
## Player detection is a direct reference (set_player), not a group or "controller in body"
## duck-type check — the project doesn't use Godot groups anywhere, and the door only ever
## needs to know about the one player, not "any body with a controller" like Pen does.

signal opened

const STILL_VELOCITY_THRESHOLD: float = 5.0
const RADIUS: float = 40.0

@export var hold_seconds: float = 1.2

var _player: CharacterBody2D = null
var _player_inside: bool = false
var _hold_timer: float = 0.0
var _opened: bool = false

func _ready() -> void:
	collision_layer = 0
	collision_mask = CollisionLayers.PLAYER
	_build_shape()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func set_player(player: CharacterBody2D) -> void:
	_player = player

func _process(delta: float) -> void:
	queue_redraw()
	if _opened or not _player_inside or _player == null:
		return

	if _player.velocity.length() < STILL_VELOCITY_THRESHOLD:
		_hold_timer += delta
		if _hold_timer >= hold_seconds:
			_open()
	else:
		_hold_timer = 0.0

func _on_body_entered(body: Node2D) -> void:
	if body == _player:
		_player_inside = true
		_hold_timer = 0.0

func _on_body_exited(body: Node2D) -> void:
	if body == _player:
		_player_inside = false
		_hold_timer = 0.0

func is_opened() -> bool:
	return _opened

## Opened by another door's link (PenLinkResolver), not by the player. Deliberately does NOT
## emit `opened`: Level0 already releases every pen in the link set in one pass, and emitting
## here would re-enter its handler. Safe to call on an already-opened door (no-op).
func force_open() -> void:
	if _opened:
		return
	_opened = true
	queue_free()

func _open() -> void:
	_opened = true
	opened.emit()
	queue_free()

func _build_shape() -> void:
	var collision_shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = RADIUS
	collision_shape.shape = circle
	add_child(collision_shape)

	var visual := Polygon2D.new()
	visual.polygon = _circle_points(RADIUS, 16)
	visual.visible = false
	visual.color = Color(0.6, 0.4, 0.15, 1.0)  # placeholder "wooden gate" color
	add_child(visual)

func _circle_points(radius: float, segments: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in range(segments):
		var angle: float = TAU * i / segments
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	return points

func _draw() -> void:
	draw_circle(Vector2(2, 5), RADIUS, Color(0.2, 0.12, 0.06, 0.18))
	draw_circle(Vector2.ZERO, RADIUS, Color("8c6844"))
	draw_arc(Vector2.ZERO, RADIUS - 3, 0, TAU, 48, Color("f0d093"), 3, true)
	for x: float in [-18.0, 0.0, 18.0]:
		draw_line(Vector2(x, -23), Vector2(x, 23), Color("c39a61"), 9, true)
	for y: float in [-14.0, 14.0]:
		draw_line(Vector2(-25, y), Vector2(25, y), Color("e2bd7c"), 5, true)
	if _player_inside:
		var fraction: float = clampf(_hold_timer / hold_seconds, 0, 1)
		draw_arc(Vector2.ZERO, RADIUS + 5, -PI / 2, -PI / 2 + TAU * fraction, 48, Color("8fe5b6"), 5, true)
		var font: Font = ThemeDB.fallback_font
		draw_string(font, Vector2(-54, -53), "Quieto para abrir", HORIZONTAL_ALIGNMENT_CENTER, 108, 14, Color("fff2d2"))
