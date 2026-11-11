extends Node2D
const HOUSE=preload("res://art/world/cartoon/house.png")
const TREE=preload("res://art/world/cartoon/pine.png")
var modular=false
# The same entry/exit and landmarks in both images. Isolated design example.
var smooth=PackedVector2Array([Vector2(60,430),Vector2(280,430),Vector2(470,250),Vector2(700,250),Vector2(920,430),Vector2(1220,430)])
var pieces=PackedVector2Array([Vector2(60,430),Vector2(365,430),Vector2(365,250),Vector2(810,250),Vector2(810,430),Vector2(1220,430)])
func _ready():
 get_tree().root.size=Vector2i(1280,720)
 capture.call_deferred()
func label(text:String,pos:Vector2,size:int=23):
 draw_string(ThemeDB.fallback_font,pos,text,HORIZONTAL_ALIGNMENT_LEFT,-1,size,Color("fff0ce"))
func _draw():
 draw_rect(Rect2(0,0,1280,720),Color("32653a"))
 draw_rect(Rect2(0,0,1280,75),Color("102d24"))
 label("EJEMPLO - piezas de Ant en el camino largo" if modular else "ANTES - camino largo con rectas giradas",Vector2(32,45),29)
 # Fixed landmarks, reused art, not new images.
 var house=HOUSE
 if house!=null:draw_texture_rect(house,Rect2(530,350,130,130),false)
 var tree=TREE
 for p in [Vector2(140,155),Vector2(1020,150),Vector2(170,520),Vector2(1040,535)]:draw_texture_rect(tree,Rect2(p,Vector2(65,105)),false)
 if modular:
  RoadTiles.stamp_access(self,pieces,62,32)
  RoadTiles.stamp_access(self,PackedVector2Array([Vector2(580,250),Vector2(580,340)]),62,32)
  RoadTiles.junction(self,"t",Vector2(580,250),0,45)
  RoadTiles.stamp_access(self,PackedVector2Array([Vector2(1100,285),Vector2(1100,580)]),62,32)
  RoadTiles.junction(self,"cross",Vector2(1100,430),0,45)
 else:
  var sampled=PackedVector2Array()
  for i in smooth.size()-1:
   for j in 25:
    var t=j/24.;var a=smooth[i];var b=smooth[i+1]
    sampled.append(Vector2(lerpf(a.x,b.x,t),lerpf(a.y,b.y,smoothstep(0,1,t))))
  RoadTiles.stamp_polyline(self,sampled,62,49.6)
  RoadTiles.stamp_polyline(self,PackedVector2Array([Vector2(580,250),Vector2(580,340)]),62,32)
  RoadTiles.stamp_polyline(self,PackedVector2Array([Vector2(1100,285),Vector2(1100,580)]),62,32)
 draw_rect(Rect2(0,650,1280,70),Color("102d24"))
 label("Curvas + T + cruce + finales. Solo ejemplo visual; mundo y guardado sin cambios." if modular else "Mismos extremos y puntos de referencia. Las curvas suaves usan el tramo recto repetido.",Vector2(28,690),22)
func capture():
 for mode in [false,true]:
  modular=mode;queue_redraw()
  await get_tree().process_frame;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/camino-largo86-"+("despues" if modular else "antes")+".png")
 get_tree().quit()
