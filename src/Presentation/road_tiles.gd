class_name RoadTiles
## Shared camino stamping from Ant's cartoon art sheet (7-nov-2026 23:06).
## Ant: "si el camino queda bien en Frontera lo utilizaremos también en las
## misiones" — one component for world trails and, later, the levels.
## road_seg.png is the seamless straight section of the sheet's vertical road
## tile (dirt reaches both ends, so stamps join without seams).

const SEG_TEX: Texture2D = preload("res://art/world/cartoon/road_seg.png")
const CORNER_TEX: Texture2D = preload("res://art/world/cartoon/road_corner.png")
const CROSS_TEX: Texture2D = preload("res://art/world/cartoon/road_cross.png")
const T_TEX: Texture2D = preload("res://art/world/cartoon/road_t.png")
const END_TEX: Texture2D = preload("res://art/world/cartoon/road_end.png")

## One straight stamp, centred, rotated so the dirt lies along `angle`.
## `length` is the stamp length along the path; width follows the art aspect.
static func stamp(node: CanvasItem, center: Vector2, angle: float, length: float) -> void:
	var w := length * SEG_TEX.get_width() / float(SEG_TEX.get_height())
	node.draw_set_transform(center, angle + PI * 0.5, Vector2.ONE)
	node.draw_texture_rect(SEG_TEX, Rect2(-w * 0.5, -length * 0.5, w, length), false)
	node.draw_set_transform(Vector2.ZERO)

## Stamp along a sampled polyline; `step` = distance between stamp centres.
## Overlap of 20% hides the joints on bends.
static func stamp_polyline(node: CanvasItem, points: PackedVector2Array, length: float, step: float) -> void:
	if points.size() < 2:
		return
	var acc := 0.0
	var next := step * 0.5
	for i in points.size() - 1:
		var a := points[i]
		var b := points[i + 1]
		var seg := b - a
		var seg_len := seg.length()
		while acc + seg_len >= next:
			var f := (next - acc) / seg_len
			stamp(node, a.lerp(b, f), seg.angle(), length)
			next += step * 0.8
		acc += seg_len
