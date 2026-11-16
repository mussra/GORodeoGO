class_name WorldMountains103
extends Node2D
## Existing V3 separators: same collision geometry, shared town-colored wall finish.
var seed:int
var chunk:Vector2i
var ridges:Array=[]
func _ready():
 z_index=-6
 ridges=WorldTerrain103.ridges_for_chunk(seed,chunk)
 for item in ridges:
  var body:StaticBody2D
  if item.has("town227"):
   body=WorldPhysics.add_box(self,Rect2(Vector2.ZERO,Vector2((item.b as Vector2).distance_to(item.a),TownEnclosures227.THICKNESS)))
   body.position=(item.a+item.b)*.5;body.rotation=(item.b-item.a).angle()
   for end in [item.a,item.b]:
    var cap:=StaticBody2D.new();cap.position=end;cap.collision_layer=128;cap.collision_mask=0;cap.add_to_group("world_mountain103")
    var collision:=CollisionShape2D.new();var circle:=CircleShape2D.new();circle.radius=TownEnclosures227.THICKNESS*.5;collision.shape=circle;cap.add_child(collision);add_child(cap)
  else:body=WorldPhysics.add_box(self,item.box)
  body.collision_layer=128;body.collision_mask=0;body.add_to_group("world_mountain103")
 queue_redraw()
func _draw():
 if SaveData.world_generator_version>=4:
  texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED
  TownWallArt242.draw(self,seed,chunk);return
 var gates:Dictionary={}
 texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED
 for item in ridges:
  if item.has("town227"):
   var look227:=TownIdentity215.look(SaveData.world_cousins140,item.town227)
   var a:Vector2=item.a;var b:Vector2=item.b;var normal:Vector2=(b-a).normalized().orthogonal()*TownEnclosures227.THICKNESS*.5
   var polygon:=PackedVector2Array([a+normal,b+normal,b-normal,a-normal]);var uv:=PackedVector2Array()
   for point in polygon:uv.append(point/128.)
   draw_polyline(PackedVector2Array([a,b]),Color("514537"),TownEnclosures227.THICKNESS+8.,true)
   draw_polygon(polygon,PackedColorArray([Color.WHITE]),uv,TownPaint215.texture(look227))
   draw_line(a+normal,b+normal,Color("f3dfb3"),6.,true);draw_line(a-normal,b-normal,Color("6e5b45"),5.,true)
   continue
  var id:String=TownIdentity215.nearest(SaveData.world_cousins140,item.port)
  var look:=TownIdentity215.look(SaveData.world_cousins140,id)
  var parts:PackedStringArray=str(item.id).split("_")
  var source:Dictionary=WorldTerrain103.ridge(seed,int(parts[1]),int(parts[2]))
  TownPaint215.wall(self,item.box,look,source.boxes[0].size.x,item.port.x)
  var bounds:=Rect2(Vector2(chunk)*1024.,Vector2.ONE*1024.)
  if bounds.has_point(item.port) and not gates.has(item.id):
   gates[item.id]=true
   # Original opening stays 160 wide, aligned to the existing through road.
   for side in [-1,1]:
    var point:Vector2=item.port+Vector2(0,side*80.)
    draw_style_box(RanchTheme.box(Color(look.base),Color("624a31"),5),Rect2(point-Vector2(60,14),Vector2(120,28)))
    draw_line(point+Vector2(-60,-12),point+Vector2(60,-12),Color("f4dfb5"),6.)
   draw_string(ThemeDB.fallback_font,item.port+Vector2(-130,-110),TownIdentity215.title(SaveData.world_cousins140,id),HORIZONTAL_ALIGNMENT_LEFT,-1,17,Color("fff1cd"))
