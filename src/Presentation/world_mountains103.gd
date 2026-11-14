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
  var body=WorldPhysics.add_box(self,item.box);body.collision_layer=128;body.collision_mask=0;body.add_to_group("world_mountain103")
 queue_redraw()
func _draw():
 var gates:Dictionary={}
 texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED
 for item in ridges:
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
