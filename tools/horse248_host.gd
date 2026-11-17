extends Node2D
var seed_:int=752026
var plan:Dictionary={}
func road_surface_contains94(_p:Vector2,_m:float=0.)->bool:return false
func mountain_step103(a:Vector2,b:Vector2)->Vector2:return WorldTerrain103.safe_step(seed_,a,b)
func _draw():
 texture_repeat=TownPaint215.REPEAT248
 var geometry:=TownWallArt242.geometry(plan);var look:Dictionary={'base':'ead7aa','spot':'4b9b77','pattern':9}
 for layer_ in ['outer','surface','inset']:
  for p in geometry[layer_]:
   var uv:=PackedVector2Array()
   for v in p:uv.append(TownPaint215.uv248(v))
   if layer_=='inset':draw_polygon(p,PackedColorArray([Color.WHITE]),uv,TownPaint215.texture(look))
   else:draw_colored_polygon(p,Color('514537') if layer_=='outer' else Color('ead7aa'))
