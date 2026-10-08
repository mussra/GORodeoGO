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

const LINK_COLOR: Color = Color(1.0, 0.41, 0.71, 1.0)  # pink
const LINK_WIDTH: float = 3.0
const ARROWHEAD_LENGTH: float = 16.0
const ARROWHEAD_WIDTH: float = 8.0

var _pens: Array = []
var _doors: Array = []  # PenDoor per pen index; entries may be freed instances, hence untyped

func setup(pens: Array, doors: Array) -> void:
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

	var tip: Vector2 = to - direction * PenDoor.RADIUS
	draw_line(from, tip, LINK_COLOR, LINK_WIDTH)

	var perpendicular: Vector2 = Vector2(-direction.y, direction.x)
	var base_left: Vector2 = tip - direction * ARROWHEAD_LENGTH + perpendicular * ARROWHEAD_WIDTH
	var base_right: Vector2 = tip - direction * ARROWHEAD_LENGTH - perpendicular * ARROWHEAD_WIDTH
	draw_polygon(PackedVector2Array([tip, base_left, base_right]), PackedColorArray([LINK_COLOR]))

func _is_door_closed(door) -> bool:
	return is_instance_valid(door) and not door.is_opened()
