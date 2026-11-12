class_name WorldNominal98
extends RefCounted
## V2 nominal road network: infinite monotonic E-W trunk, finite seeded branches.
## No stored/legacy world is routed here without its own explicit version=2.
const Layout=preload("res://src/Presentation/modular_world_layout93.gd")
static func enabled()->bool:return SaveData.world_generator_version>=2
static func doors()->Dictionary:return WorldTerrain103.plan(SaveData.world_seed).doors if SaveData.world_generator_version>=3 else Layout.DOORS
static func home()->Vector2:return Layout.world(doors().ranch)+Vector2(0,70)
static func board()->Vector2:return Layout.world(doors().ranch)+Vector2(100,40)
static func graph_for_chunk(seed:int,c:Vector2i,version:int=2)->Dictionary:
 if version>=3:return WorldTerrain103.graph_for_chunk(seed,c)
 var local:Dictionary=Layout.graph(seed);var out:Dictionary={}
 var bounds:Rect2=Rect2(Vector2(c)*WorldMap.CHUNK_SIZE,Vector2.ONE*WorldMap.CHUNK_SIZE).grow(80)
 for cell in local:
  if bounds.has_point(Layout.world(cell)):out[cell]=local[cell].duplicate()
 var min_x:int=floori((bounds.position.x-Layout.ORIGIN.x)/Layout.CELL)
 var max_x:int=ceili((bounds.end.x-Layout.ORIGIN.x)/Layout.CELL)
 for x in range(min_x,max_x+1):
  var cell=Vector2i(x,4)
  if not bounds.has_point(Layout.world(cell)):continue
  var edges:Array=local.get(cell,[]).duplicate()
  for next in [cell+Vector2i.LEFT,cell+Vector2i.RIGHT]:
   if not edges.has(next):edges.append(next)
  out[cell]=edges
 return out
static func keep_decor(d:Dictionary,surface:WorldRoadSurface94)->bool:
 if d.get("edited",false):return true # owner edits are not silently removed
 if surface.contains(d.pos,45.):return false
 # Reserve actual building footprints/doors, independent of chunk boundaries.
 for door in doors().values():
  if Rect2(Layout.world(door)-Vector2(180,220),Vector2(360,280)).has_point(d.pos):return false
 return true
