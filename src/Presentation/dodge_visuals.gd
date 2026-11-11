class_name DodgeVisuals
extends RefCounted

## Dodge/regate drawing shared by the corral rider (player.gd) and the
## open-world rider (world_player.gd) — same trail, same bullet-time preview,
## same recharge bar, same dust (Ant's unification rule: same graphics).

## Skid trail under the rider while it fades.
static func draw_trail(item: CanvasItem, skid_trail: Array, trail_fade: float, ground_offset: Vector2 = Vector2(0,27)) -> void:
	if skid_trail.size() > 1 and trail_fade > 0.0:
		var local_trail := PackedVector2Array()
		for point in skid_trail:
			local_trail.append(item.to_local(point) + ground_offset)
		draw_flash_path(item, local_trail, trail_fade / .7)

## The freehand trace while bullet-time drawing is armed (points must already
## be the DodgeCurve preview projection).
static func draw_drawing(item: CanvasItem, preview: PackedVector2Array) -> void:
	if preview.size() > 1:
		draw_flash_path(item, preview, 1.0)
		item.draw_string(ThemeDB.fallback_font, Vector2(-64, -78), "TIEMPO BALA", HORIZONTAL_ALIGNMENT_LEFT, 150, 15, Color("a7fff0"))

## Recharge bar over the rider's head.
static func draw_recharge(item: CanvasItem, anchor: Vector2, recharge: float) -> void:
	item.draw_line(anchor + Vector2(-22, 0), anchor + Vector2(22, 0), Color("263747"), 5.0)
	item.draw_line(anchor + Vector2(-22, 0), anchor + Vector2(-22 + 44 * recharge, 0), Color("77dbd5") if recharge < 1 else Color("efb950"), 4.0)

## Dust kicked up while the dash runs.
static func draw_dash_dust(item: CanvasItem, direction: Vector2, ground_offset: Vector2 = Vector2(0,28)) -> void:
	var back: Vector2 = -direction
	var side: Vector2 = direction.orthogonal()
	for i in range(4):
		var dust: Vector2 = back * (24.0 + i * 13.0) + ground_offset
		item.draw_circle(dust + side * (8 if i % 2 else -8), 9.0 - i, Color(.85, .69, .42, .55 - i * .1))
	for side_sign in [-1, 1]:
		item.draw_line(back * 12 + side * side_sign * 13 + ground_offset, back * 54 + side * side_sign * 13 + ground_offset, Color(.35, .24, .13, .6), 3.0, true)

## Layered light ribbon with moving star glints, never a plain solid line.
static func draw_flash_path(item: CanvasItem, points: PackedVector2Array, alpha: float) -> void:
	if points.size() < 2:
		return
	item.draw_polyline(points, Color(.15, .95, .92, .07 * alpha), 22.0, true)
	item.draw_polyline(points, Color(.25, 1.0, .95, .16 * alpha), 12.0, true)
	item.draw_polyline(points, Color(.50, 1.0, .95, .55 * alpha), 5.0, true)
	item.draw_polyline(points, Color(.94, 1.0, .85, .95 * alpha), 1.7, true)
	var clock: float = Time.get_ticks_msec() / 1000.0
	var distance: float = 0.0
	for segment in range(1, points.size()):
		var a: Vector2 = points[segment - 1]
		var b: Vector2 = points[segment]
		var direction: Vector2 = (b - a).normalized()
		var side: Vector2 = direction.orthogonal()
		var length: float = a.distance_to(b)
		var steps: int = maxi(1, int(length / 13.0))
		for j in range(steps):
			var p: Vector2 = a.lerp(b, float(j) / steps)
			var pulse: float = .5 + .5 * sin(clock * 18.0 + distance * .11)
			var spread: float = 2.0 + pulse * 5.0
			var shard: Vector2 = p + side * spread * (1.0 if j % 2 == 0 else -1.0)
			item.draw_line(shard - direction * 3, shard + direction * (4 + pulse * 5), Color(.7, 1.0, .94, alpha * pulse * .8), 1.3, true)
			if j % 4 == 0:
				item.draw_circle(p, 2 + pulse * 2, Color(.96, 1.0, .84, alpha * .8))
			distance += length / steps
