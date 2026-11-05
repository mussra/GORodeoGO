class_name EdgeIndicators
extends Node2D

var level: Node
var markers: Array = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta: float) -> void:
	markers.clear()
	if level == null or level._game_over or get_tree().paused:
		queue_redraw()
		return
	var size: Vector2 = get_viewport_rect().size
	var safe := Rect2(Vector2(70,110),size-Vector2(140,235))
	var transform: Transform2D = level.get_global_transform_with_canvas()
	_add_marker(transform * level.pen.global_position, safe, "META", Color("f4d383"))
	for bull in level._active_bulls:
		if not bull._delivered and bull.controller.current_state()!=BullState.State.SAFE:
			_add_marker(transform * bull.global_position, safe, "TORO", Color("efab81"), true)
	# Closed corral latches are useful navigation targets without labelling every
	# penned bull as an urgent offscreen threat.
	for i in range(level._pen_doors.size()):
		var door=level._pen_doors[i]
		if is_instance_valid(door) and not door.is_opened():
			_add_marker(transform*door.global_position,safe,"CIERRE "+str(i+1),Color("a2d6ca"),true)
	queue_redraw()

func _add_marker(target: Vector2, safe: Rect2, label: String, color: Color, group: bool = false) -> void:
	var visible_world := Rect2(Vector2(0,80),get_viewport_rect().size-Vector2(0,150))
	if visible_world.has_point(target): return
	var point: Vector2 = ArenaLayout.edge_point(target,safe)
	if group:
		for marker in markers:
			if marker["label"] == label and point.distance_to(marker["point"]) < 58:
				marker["count"] += 1
				return
	markers.append({"point":point,"direction":(target-safe.get_center()).normalized(),"label":label,"color":color,"count":1})

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
