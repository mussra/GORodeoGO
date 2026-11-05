class_name PenLinkOverlay
extends Node2D

## One readable cartoon dirt trail at a time: nearest still-closed source latch,
## or the next leg of a courier already running. Never layer the whole network.
var _pens:Array=[]
var _doors:Array=[]
var layouts:Array=[]
var focus_player:Node2D
var active_route:PackedVector2Array=PackedVector2Array()
var active_from:int=-1
var active_to:int=-1
var _shown_from:int=-2
var _shown_to:int=-2
func setup(pens:Array,doors:Array) -> void:
	z_index=-5
	_pens=pens
	_doors=doors
func _process(_delta:float) -> void:
	var source:int=-1
	var target:int=-1
	if active_from>=0:
		source=active_from
		target=active_to
	elif is_instance_valid(focus_player):
		var nearest:float=160.0
		for i in range(layouts.size()):
			if i>=_doors.size() or not is_instance_valid(_doors[i]):continue
			var linked:Array=PenLinkResolver.get_linked_pen_indices(_pens,i)
			var distance:float=focus_player.global_position.distance_to(layouts[i]["door"])
			if not linked.is_empty() and distance<nearest:
				nearest=distance;source=i;target=linked[0]
	if source!=_shown_from or target!=_shown_to:
		_shown_from=source;_shown_to=target;queue_redraw()
func _draw() -> void:
	if _shown_from<0 or _shown_to<0 or layouts.is_empty():return
	var path:PackedVector2Array=CorralRoute.build(layouts[_shown_from],layouts[_shown_to])
	# Wide earth trail with dark cartoon outline, soft shoulder and warm centre.
	draw_polyline(path,Color("30454b"),29,true)
	draw_polyline(path,Color("8c6947"),25,true)
	draw_polyline(path,Color("cda774"),19,true)
	for i in range(1,path.size()):
		var a:Vector2=path[i-1];var b:Vector2=path[i]
		var side:Vector2=(b-a).normalized().orthogonal()
		var count:int=maxi(1,int(a.distance_to(b)/36))
		for j in range(count):
			var p:Vector2=a.lerp(b,(j+.5)/count)
			draw_line(p-side*5,p-side*1,Color("b28b5d"),2,true)
	# Ranch signposts make source and next destination explicit without abstract arrows.
	_sign(layouts[_shown_from]["door"]+Vector2(-35,0),str(_shown_from+1))
	_sign(layouts[_shown_to]["door"]+Vector2(35,0),"A "+str(_shown_to+1))
func _sign(at:Vector2,text:String) -> void:
	draw_line(at+Vector2(0,0),at+Vector2(0,-29),Color("8a6849"),5,true)
	draw_style_box(RanchTheme.box(Color("edd3a0"),Color("76563c"),4),Rect2(at+Vector2(-20,-45),Vector2(40,25)))
	draw_string(ThemeDB.fallback_font,at+Vector2(-17,-27),text,HORIZONTAL_ALIGNMENT_CENTER,34,14,Color("543e2f"))
