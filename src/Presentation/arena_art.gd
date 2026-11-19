class_name ArenaArt
extends Node2D

const SAND310=preload("res://art/arena310/sand-mirror-tile.png")
const FENCE310=preload("res://art/arena310/fence-horizontal.png")

## Decorative layer only. Collision and level geometry remain owned by the scene/catalog.
var obstacle_rects: Array = []
var world_bounds:Rect2=Rect2(-480,-270,960,540)
var pen_position: Vector2 = Vector2(-300, 0)

func _ready() -> void:
	z_index = -20
	queue_redraw()

func _draw() -> void:
	# Ant's illustrated floor. Mirror-derived repeat of the supplied interior crop;
	# no painted border is repeated and collision bounds remain unchanged.
	texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED
	draw_rect(world_bounds.grow(350), Color("294b36"))
	var floor_box:=world_bounds.grow(15)
	var points:=PackedVector2Array([floor_box.position,Vector2(floor_box.end.x,floor_box.position.y),floor_box.end,Vector2(floor_box.position.x,floor_box.end.y)])
	var uv:=PackedVector2Array()
	for point in points:uv.append(point/435.)
	draw_polygon(points,PackedColorArray([Color.WHITE]),uv,SAND310)
	# Supplied horizontal fence modules, uniformly scaled, no stretching.
	var count:=maxi(1,int(ceil(world_bounds.size.x/155.)))
	var width:=world_bounds.size.x/count
	var height:=width*FENCE310.get_height()/FENCE310.get_width()
	for y in [world_bounds.position.y-10]:
		for i in count:
			var x:=world_bounds.position.x+i*width
			draw_texture_rect(FENCE310,Rect2(x,y-height*.80,width+1,height),false)
	# Whole supplied three-post images. End posts overlap at their centers.
	# Uniform scale; align the art with the horizontal corner posts, not collision edits.
	var side_count:=maxi(1,int(round((world_bounds.size.y+20)/290.)))
	var side_scale:float=(world_bounds.size.y+20)/(2164.+(side_count-1)*1790.)
	var side_size:=Vector2(155.,2164.)*side_scale
	for x:float in [world_bounds.position.x+10,world_bounds.end.x-10]:
		for i in side_count:
			var y:float=world_bounds.position.y-10+i*1790.*side_scale
			draw_texture_rect(CorralArt310.VERTICAL312,Rect2(Vector2(x-side_size.x*.5,y),side_size),false)
	# Foreground bottom rail covers the vertical end posts at both corners.
	for i in count:
		var x:float=world_bounds.position.x+i*width
		draw_texture_rect(FENCE310,Rect2(x,world_bounds.end.y+10-height*.80,width+1,height),false)
	var random := RandomNumberGenerator.new()
	random.seed=93842
	for rect: Rect2 in obstacle_rects:
		_crates(rect)
	_draw_destination()
	# Small grass clumps outside the playable fence.
	for side: int in [-1, 1]:
		for i in range(13):
			var p := Vector2(side * random.randf_range(world_bounds.size.x/2+55,world_bounds.size.x/2+170), random.randf_range(world_bounds.position.y-60,world_bounds.end.y+60))
			for j in range(3):
				draw_line(p + Vector2(j * 4, 0), p + Vector2(j * 5 - 3, -10 - j * 2), Color("1e4655"), 3, true)

func _post(point: Vector2) -> void:
	draw_circle(point + Vector2(2, 5), 7, Color(0.2, 0.13, 0.1, 0.2))
	draw_rect(Rect2(point - Vector2(5, 9), Vector2(10, 18)), Color("1a333e"))
	draw_rect(Rect2(point - Vector2(4, 9), Vector2(8, 5)), Color("9eead8"))

func _crates(rect: Rect2) -> void:
	draw_style_box(RanchTheme.box(Color(0.2, 0.13, 0.07, 0.22), Color.TRANSPARENT, 5), Rect2(rect.position + Vector2(4, 6), rect.size))
	draw_style_box(RanchTheme.box(Color("264c59"), Color("9bbaba"), 4), rect)
	var inner: Rect2 = rect.grow(-7)
	draw_rect(inner, Color("88b4b9"), false, 3)
	draw_line(inner.position, inner.end, Color("173c4b"), 4)
	draw_line(Vector2(inner.position.x, inner.end.y), Vector2(inner.end.x, inner.position.y), Color("173c4b"), 4)

## Decorative receiving corral. The lit80x80 floor is the unchanged delivery zone;
## four open approaches and corner rails do not introduce any physical obstacles.
func _draw_destination() -> void:
	var p: Vector2 = pen_position
	var goal := Rect2(p - Vector2(40,40),Vector2(80,80))
	draw_style_box(RanchTheme.box(Color(.02,.10,.13,.35),Color.TRANSPARENT,16),goal.grow(11))
	draw_style_box(RanchTheme.box(Color("594b39"),Color("b89b66"),8),goal.grow(4))
	draw_style_box(RanchTheme.box(Color("246460"),Color("a4f5d4"),7),goal)
	for y in range(-28,32,12):
		draw_line(p+Vector2(-33,y),p+Vector2(33,y),Color(.75,.9,.69,.13),2,true)
	# Short wooden corner rails leave64px clear at every side, never a closed gate.
	for x in [-1,1]:
		for y in [-1,1]:
			var corner:Vector2=p+Vector2(x*48,y*48)
			draw_line(corner,corner+Vector2(-x*15,0),Color("d2b27c"),5,true)
			draw_line(corner,corner+Vector2(0,-y*15),Color("d2b27c"),5,true)
			draw_style_box(RanchTheme.box(Color("66523d"),Color("d8bd8a"),2),Rect2(corner-Vector2(4,6),Vector2(8,13)))
			draw_circle(corner-Vector2(0,4),2,Color("9cf7d7"))
	# Ranch horseshoe badge; no opaque structure hides bulls over the floor.
	draw_arc(p+Vector2(0,-2),16,-.15,PI+.15,24,Color("e5c47d"),4,true)
	draw_line(p+Vector2(-16,-3),p+Vector2(-16,-12),Color("e5c47d"),4,true)
	draw_line(p+Vector2(16,-3),p+Vector2(16,-12),Color("e5c47d"),4,true)
	for x in [-10,10]:draw_circle(p+Vector2(x,7),1.5,Color("564f40"))
	draw_style_box(RanchTheme.box(Color("213f49"),Color("bba271"),4),Rect2(p+Vector2(-43,-76),Vector2(86,23)))
	draw_string(ThemeDB.fallback_font,p+Vector2(-38,-59),"RANCHO",HORIZONTAL_ALIGNMENT_CENTER,76,14,Color("fff0c5"))
	# A gold inward chevron makes the front approach visible under the dark floor.
	draw_polyline(PackedVector2Array([p+Vector2(-7,55),p+Vector2(0,49),p+Vector2(7,55)]),Color("c8ead5"),2,true)
