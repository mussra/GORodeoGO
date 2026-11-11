class_name WorldGrassTexture
extends Node2D
## One pre-baked texture shared by every chunk. No alpha layers or per-cell draws.
const CACHE=preload("res://art/world/derived88/grass-cache91.png")
const PERIOD=1024.0
var c:Vector2i
# Kept for existing deterministic variant tests and compatibility; no tile grid drawn.
static func variant(seed:int,cell:Vector2i)->int:return posmod(hash("grass89:%d:%d:%d"%[seed,cell.x,cell.y]),3)
static func uv_at(seed:int,point:Vector2)->Vector2:
 var offset=Vector2(posmod(seed,997),posmod(seed*31,991))
 return (point+offset)/PERIOD
func _ready():
 z_index=-9;texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED;queue_redraw()
func _draw():
 var origin=Vector2(c)*WorldMap.CHUNK_SIZE
 var points=PackedVector2Array();var uvs=PackedVector2Array()
 for corner in [Vector2.ZERO,Vector2.RIGHT,Vector2.ONE,Vector2.DOWN]:
  var p=origin+corner*WorldMap.CHUNK_SIZE;points.append(p);uvs.append(uv_at(SaveData.world_seed,p))
 draw_polygon(points,PackedColorArray([Color.WHITE]),uvs,WorldTerrainPreview92.GRASS if WorldTerrainPreview92.alternative else CACHE)
