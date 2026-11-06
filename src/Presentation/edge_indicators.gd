class_name EdgeIndicators
extends Node2D

var level: Node
var markers: Array = []
# Schmitt band plus dwell: camera/bull motion at the visibility boundary must
# not rebuild a disappearing arrow every frame. State belongs to the target.
const SHOW_MARGIN: float = 16.0
const HIDE_MARGIN: float = 24.0
const SHOW_DWELL: float = 0.10
const HIDE_DWELL: float = 0.15
var _visibility: Dictionary = {}
var _seen: Dictionary = {}
var _frame_delta: float = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	markers.clear()
	_seen.clear()
	_frame_delta = delta
	if level == null or level._game_over or get_tree().paused:
		queue_redraw()
		return
	var size: Vector2 = get_viewport_rect().size
	var safe := Rect2(Vector2(70,110),size-Vector2(140,235))
	var transform: Transform2D = level.get_global_transform_with_canvas()
	_add_marker(transform * level.pen.global_position, safe, "META", Color("f4d383"), false, level.pen.get_instance_id())
	for bull in level._active_bulls:
		if is_instance_valid(bull) and not bull._delivered and bull.controller.current_state()!=BullState.State.SAFE:
			_add_marker(transform * bull.global_position, safe, "TORO", Color("efab81"), true, bull.get_instance_id())
	# Closed corral latches are useful navigation targets without labelling every
	# penned bull as an urgent offscreen threat.
	for i in range(level._pen_doors.size()):
		var door=level._pen_doors[i]
		if is_instance_valid(door) and not door.is_opened():
			_add_marker(transform*door.global_position,safe,"CIERRE "+str(i+1),Color("a2d6ca"),true,door.get_instance_id())
	for key in _visibility.keys():
		if not _seen.has(key): _visibility.erase(key)
	queue_redraw()

func _add_marker(target: Vector2, safe: Rect2, label: String, color: Color, group: bool = false, target_id: int = 0) -> void:
	var visible_world := Rect2(Vector2(0,80),get_viewport_rect().size-Vector2(0,150))
	_seen[target_id] = true
	if not _marker_visible(target_id, target, visible_world, _frame_delta): return
	var point: Vector2 = ArenaLayout.edge_point(target,safe)
	if group:
		for marker in markers:
			if marker["label"] == label and point.distance_to(marker["point"]) < 58:
				marker["count"] += 1
				return
	markers.append({"point":point,"direction":(target-safe.get_center()).normalized(),"label":label,"color":color,"count":1})

func _marker_visible(target_id: int, target: Vector2, visible: Rect2, delta: float) -> bool:
	var state: Dictionary = _visibility.get(target_id, {"shown":false,"dwell":0.0})
	var shown: bool = state["shown"]
	# At the threshold itself retain the prior state; both sides get a band.
	var inner: Rect2 = visible.grow(-HIDE_MARGIN)
	var outer: Rect2 = visible.grow(SHOW_MARGIN)
	var inside: bool = target.x >= inner.position.x and target.x <= inner.end.x and target.y >= inner.position.y and target.y <= inner.end.y
	var outside: bool = target.x < outer.position.x or target.x > outer.end.x or target.y < outer.position.y or target.y > outer.end.y
	var switching: bool = inside if shown else outside
	state["dwell"] = float(state["dwell"]) + maxf(delta, 0.0) if switching else 0.0
	if float(state["dwell"]) >= (HIDE_DWELL if shown else SHOW_DWELL):
		state["shown"] = not shown
		state["dwell"] = 0.0
	_visibility[target_id] = state
	return state["shown"]

func _draw() -> void:
	for marker in markers:
		var p: Vector2 = marker["point"]
		var direction: Vector2 = marker["direction"]
		var color: Color = marker["color"]
		draw_circle(p,24,Color("243a34"))
		draw_style_box(RanchTheme.box(Color("243a34"),Color.TRANSPARENT,6),Rect2(p+Vector2(-37,22),Vector2(74,23)))
		var tip: Vector2 = p+direction*17
		var base: Vector2 = p-direction*6
		draw_colored_polygon(PackedVector2Array([tip,base+direction.orthogonal()*9,base-direction.orthogonal()*9]),color)
		var text: String = marker["label"] + (" ×%d" % marker["count"] if marker["count"] > 1 else "")
		draw_string(ThemeDB.fallback_font,p+Vector2(-36,41),text,HORIZONTAL_ALIGNMENT_CENTER,72,15,color)
