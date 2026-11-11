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

# Same supplied art, isolated connected corner only. Original PNG stays intact.
const CLEAN_CORNER=preload("res://art/world/cartoon/derived/road_corner_clean.png")
## Draw a supplied junction around its road centre, not its bounding-box centre.
## Angles describe the original art: corner UP+RIGHT, T LEFT+RIGHT+DOWN,
## cross all four directions, end opening RIGHT with a rounded LEFT tip.
static func junction(node:CanvasItem,kind:String,center:Vector2,angle:float,width:float)->void:
	var tex:Texture2D
	var pivot:Vector2
	var band:float
	match kind:
		"corner":tex=CLEAN_CORNER;pivot=Vector2(40,155);band=76.0
		"t":tex=T_TEX;pivot=Vector2(115,38);band=76.0
		"cross":tex=CROSS_TEX;pivot=Vector2(79,100);band=70.0
		"end":tex=END_TEX;pivot=Vector2(113,35);band=70.0
		_:return
	var sc=width/band
	node.draw_set_transform(center,angle,Vector2.ONE*sc)
	node.draw_texture_rect(tex,Rect2(-pivot,tex.get_size()),false)
	node.draw_set_transform(Vector2.ZERO)

## Exact right-angle accesses use the supplied curves instead of rotated
## straight stamps overlapping at the corner. Terrain/path geometry is unchanged.
static func stamp_access(node:CanvasItem,points:PackedVector2Array,length:float,step:float)->void:
	if points.size()<2:return
	var width=length*SEG_TEX.get_width()/float(SEG_TEX.get_height())
	var turns={}
	for i in range(1,points.size()-1):
		var incoming=(points[i]-points[i-1]).normalized()
		var outgoing=(points[i+1]-points[i]).normalized()
		if absf(incoming.dot(outgoing))>.01:continue
		# Rotate original UP+RIGHT arms onto the two outward directions.
		var arms=[-incoming,outgoing]
		for quarter in 4:
			var a=quarter*PI*.5
			if (Vector2.UP.rotated(a).dot(arms[0])>.99 and Vector2.RIGHT.rotated(a).dot(arms[1])>.99) or (Vector2.UP.rotated(a).dot(arms[1])>.99 and Vector2.RIGHT.rotated(a).dot(arms[0])>.99):
				turns[i]=a;break
	for i in points.size()-1:
		var a=points[i];var b=points[i+1];var dir=(b-a).normalized()
		var trim=minf(width*1.4,a.distance_to(b)*.35)
		if turns.has(i):a+=dir*trim
		if turns.has(i+1):b-=dir*trim
		stamp_polyline(node,PackedVector2Array([a,b]),length,step)
	for i in turns:junction(node,"corner",points[i],turns[i],width)
	var direction=(points[-1]-points[-2]).normalized()
	# Put the cap's rounded tip at the threshold, not past the doorway.
	if points[-1].distance_to(points[-2])>width*3.0:
		junction(node,"end",points[-1]-direction*width*1.6,direction.angle()+PI,width)
