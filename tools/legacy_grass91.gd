extends Node2D
## Pure rendering, deterministic global cells, never writes saves or terrain.
const TEX=[preload("res://art/world/derived88/grass-blend-0.png"),preload("res://art/world/derived88/grass-blend-1.png"),preload("res://art/world/derived88/grass-blend-2.png")]
const STEP=96.0
const SIZE=160.0
var c:Vector2i
static func variant(seed:int,cell:Vector2i)->int:return posmod(hash("grass89:%d:%d:%d"%[seed,cell.x,cell.y]),3)
func _ready():z_index=-9;texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;queue_redraw()
func _draw():
 var origin=Vector2(c)*WorldMap.CHUNK_SIZE
 draw_rect(Rect2(origin,Vector2.ONE*WorldMap.CHUNK_SIZE),Color("78a52a"))
 var lo=Vector2i((origin-Vector2.ONE*SIZE)/STEP);var hi=Vector2i((origin+Vector2.ONE*(WorldMap.CHUNK_SIZE+SIZE))/STEP)
 var rect=Rect2(origin,Vector2.ONE*WorldMap.CHUNK_SIZE)
 for y in range(lo.y,hi.y+1):
  for x in range(lo.x,hi.x+1):
   var cell=Vector2i(x,y);var full=Rect2(Vector2(cell)*STEP,Vector2.ONE*SIZE);var clipped=full.intersection(rect)
   if not clipped.has_area():continue
   var region=Rect2((clipped.position-full.position)/SIZE*192,clipped.size/SIZE*192)
   draw_texture_rect_region(TEX[variant(SaveData.world_seed,cell)],clipped,region)
