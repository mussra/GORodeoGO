class_name WorldMountains103
extends Node2D
## Provisional code art, explicitly not Ant's final raster mountain sheet.
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
 for item in ridges:
  var box:Rect2=item.box
  draw_rect(box,Color("504d60"))
  var x:float=box.get_center().x
  var row:float=floorf(box.position.y/80.)*80.
  while row<box.end.y:
   var top:float=maxf(row,box.position.y);var bottom:float=minf(row+80.,box.end.y)
   draw_colored_polygon(PackedVector2Array([Vector2(box.position.x, bottom),Vector2(x,top),Vector2(box.end.x,bottom)]),Color("8c879a"))
   draw_line(Vector2(x,top),Vector2(box.end.x,bottom),Color("b7afbd"),3.)
   row+=80.
