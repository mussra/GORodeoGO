class_name PenLinkOverlay
extends Node2D

## Presentation layer: VALIDATION AID for pen-door links. Draws a pink ARROW from every
## still-closed door to each still-closed door it will also open (a master door → all the
## others; a chain door → its target(s)), arrowhead pointing at the door that gets opened —
## links are directional (D025/D026), the arrow makes that direction readable at a glance.
## A mutually-linked pair (each door opens the other, see level 18+) simply draws two
## opposing arrows on the same line. Placeholder only: the vertical slice replaces it with
## real art (paths the bulls follow to open the other doors). Which doors are linked is
## decided by PenLinkResolver — this node only draws, it owns no rules.
##
## An arrow disappears as soon as either end is opened: once the source is open its links
## are spent, and a target opened earlier can no longer be triggered.

const LINK_COLOR: Color = Color(0.12, 0.29, 0.24, 0.8)  # pink
const LINK_WIDTH: float = 2.0
const ARROWHEAD_LENGTH: float = 16.0
const ARROWHEAD_WIDTH: float = 8.0

var focus_player: Node2D
var goal_position: Vector2 = Vector2(-300,0)

var _pens: Array = []
var _doors: Array = []  # PenDoor per pen index; entries may be freed instances, hence untyped

func setup(pens: Array, doors: Array) -> void:
	z_index = -5  # Links stay behind characters and gates.
	_pens = pens
	_doors = doors
	queue_redraw()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	for source_index in range(_pens.size()):
		var source = _doors[source_index]
		if not _is_door_closed(source):
			continue
		if is_instance_valid(focus_player) and source.position.distance_to(focus_player.global_position) > 260:
			continue  # large maps reveal only nearby door connections, not a web across the arena
		if not _is_door_closed(source):
			continue
		for target_index: int in PenLinkResolver.get_linked_pen_indices(_pens, source_index):
			var target = _doors[target_index]
			if _is_door_closed(target):
				_draw_arrow(source.position, target.position)

## A straight line plus a filled triangular arrowhead just short of the target door's edge
## (PenDoor.RADIUS), so the tip doesn't sit hidden under the door's own circle.
func _draw_arrow(from: Vector2, to: Vector2) -> void:
	var direction: Vector2 = (to - from).normalized()
	if direction == Vector2.ZERO:
		return

	var tip: Vector2 = to - direction * 25.0
	var start: Vector2 = from + direction * 25.0
	# Split links around the unique destination label/goal instead of crossing it.
	var avoid := Rect2(goal_position - Vector2(45,68), Vector2(90,116))
	var previous: Vector2 = start
	for step in range(1, 61):
		var point: Vector2 = start.lerp(tip, float(step) / 60)
		if not avoid.has_point(point) and not avoid.has_point(previous):
			draw_line(previous, point, LINK_COLOR, LINK_WIDTH, true)
		previous = point

	var perpendicular: Vector2 = Vector2(-direction.y, direction.x)
	var base_left: Vector2 = tip - direction * ARROWHEAD_LENGTH + perpendicular * ARROWHEAD_WIDTH
	var base_right: Vector2 = tip - direction * ARROWHEAD_LENGTH - perpendicular * ARROWHEAD_WIDTH
	draw_polygon(PackedVector2Array([tip, base_left, base_right]), PackedColorArray([LINK_COLOR]))

func _is_door_closed(door) -> bool:
	return is_instance_valid(door) and not door.is_opened()
