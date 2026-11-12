class_name WorldRoadSurface94
extends RefCounted
## Gameplay surface follows the displayed road, not the whole tile rectangle.
static var images:Dictionary={}
var seed:int
var modular:bool
var dark:bool
var nominal:bool=false
var version:int=2
var region_graphs:Dictionary={}
var graph:Dictionary
var pieces:Dictionary={}
var lanes:Array=[]
var axis_points:Dictionary={}
func _init(world_seed:int=0,is_modular:bool=false,is_dark:bool=false,is_nominal:bool=false,generator_version:int=2):
 seed=world_seed;modular=is_modular;dark=is_dark;nominal=is_nominal;version=generator_version
 if modular:
  graph=ModularWorldLayout93.graph(world_seed if nominal else ModularWorldLayout93.DEFAULT_SEED)
  for cell in graph:pieces[cell]=ModularWorldLayout93.piece(graph,cell)
 else:
  for lane in WorldPaths.access_lanes(seed):lanes.append(ContinuousRoadArt.rounded(lane,32.))
func contains(point:Vector2,margin:float=0.)->bool:
 if not modular:return _legacy_contains(point,margin)
 if _contains(point):return true
 if margin>0:
  for i in 8:
   if _contains(point+Vector2.from_angle(i*TAU/8)*margin):return true
 return false
func _contains(point:Vector2)->bool:
 if modular:
  var cell:Vector2i=Vector2i(((point-ModularWorldLayout93.ORIGIN)/ModularWorldLayout93.CELL+Vector2.ONE*.5).floor())
  if nominal and version>=3:
   var chunk:Vector2i=WorldMap.chunk_at(point)
   if not region_graphs.has(chunk):
    if region_graphs.size()>32:region_graphs.clear()
    region_graphs[chunk]=WorldTerrain103.graph_for_chunk(seed,chunk)
   var nearby:Dictionary=region_graphs[chunk]
   if not nearby.has(cell):return false
   if pieces.size()>2048:pieces.clear()
   pieces[cell]=ModularWorldLayout93.piece(nearby,cell)
  if not pieces.has(cell):
   if nominal and cell.y==4:pieces[cell]={"kind":"straight","rotation":0}
   else:return false
  if nominal and version==2 and cell.y==4:
   var edges:Array=graph.get(cell,[]).duplicate()
   for next in [cell+Vector2i.LEFT,cell+Vector2i.RIGHT]:
    if not edges.has(next):edges.append(next)
   pieces[cell]=ModularWorldLayout93.piece({cell:edges},cell)
  var piece:Dictionary=pieces[cell]
  var local:Vector2=(point-ModularWorldLayout93.world(cell)).rotated(-piece.rotation*PI/2)
  var uv:Vector2=local/ModularWorldLayout93.CELL+Vector2.ONE*.5
  var key:String=("dark/" if dark else "light/")+piece.kind
  if not images.has(key):
   var name:String="tee" if piece.kind=="t" else piece.kind
   images[key]=load("res://art/world/"+("alternative92/" if dark else "derived88/")+name+".png").get_image()
  var image:Image=images[key]
  var p:Vector2i=Vector2i(uv*Vector2(image.get_size())).clamp(Vector2i.ZERO,image.get_size()-Vector2i.ONE)
  var color:Color=image.get_pixelv(p)
  return color.a>.5 and color.r>color.g*1.03 and color.r>color.b*1.3
 return false
func _legacy_contains(point:Vector2,margin:float)->bool:
 # Main ribbons are 45 wide, local accesses 32 wide. Sample the same 24-unit
 # segments used for drawing so the shoulder is not a 46-unit-wide bonus zone.
 for main in [true,false]:
  var t:float=point.x if main else point.y
  var chunk_start:float=floorf(t/WorldMap.CHUNK_SIZE)*WorldMap.CHUNK_SIZE
  var index:int=floori((t-chunk_start)/24.)
  for i in range(index-2,index+3):
   var a_t:float=chunk_start+i*24.;var b_t:float=a_t+24.
   var a:Vector2=_axis_point(main,a_t)
   var b:Vector2=_axis_point(main,b_t)
   if point.distance_to(Geometry2D.get_closest_point_to_segment(point,a,b))<22.5+margin:return true
 for lane in lanes:
  for i in lane.size()-1:
   if point.distance_to(Geometry2D.get_closest_point_to_segment(point,lane[i],lane[i+1]))<16.+margin:return true
 return false

func _axis_point(main:bool,t:float)->Vector2:
 var key:Vector2i=Vector2i(1 if main else 0,roundi(t/8.))
 if axis_points.size()>4096:axis_points.clear()
 if not axis_points.has(key):axis_points[key]=Vector2(t,WorldMap.trail_y_at(seed,t)) if main else Vector2(WorldMap.branch_x_at(seed,t),t)
 return axis_points[key]
