class_name FlowerExpansion138
extends Node2D
## Camera-local MultiMesh tiles. No node, process, collider or save row per flower.
const TILE:int=512
var world:Node2D
var tiles:Dictionary={}
var pending:Array[Vector2i]=[]
var desired:Dictionary={}
var last_signature:int=0
var field_signature:int=0
var descriptors:Array=[]
var remote:Node2D
var gardens:Node2D
var tile_build_usec:int=0
var built_flower_count:int=0
func _ready()->void:
 world=get_parent();descriptors=FloristJourney138.descriptors(SaveData.world_flora138,SaveData.world_seed)
 gardens=Node2D.new();gardens.y_sort_enabled=true;world.add_child.call_deferred(gardens)
 _make_gardens.call_deferred(gardens,FloristJourney138.home_door(SaveData.world_seed))
func _exit_tree()->void:
 if is_instance_valid(remote):remote.queue_free()
 if is_instance_valid(gardens):gardens.queue_free()
func _process(_delta:float)->void:
 if SaveData.world_flora138.is_empty() or not is_instance_valid(world.player):return
 var center:Vector2i=Vector2i((world.player.position/TILE).floor())
 var camera:Camera2D=get_viewport().get_camera_2d();var zoom:Vector2=camera.zoom if camera!=null else Vector2.ONE
 var signature:int=hash([center,SaveData.world_flora138.fields,get_viewport_rect().size,zoom])
 if signature!=last_signature:
  last_signature=signature;descriptors=FloristJourney138.descriptors(SaveData.world_flora138,SaveData.world_seed)
  var fs:int=hash(SaveData.world_flora138.fields)
  if field_signature!=fs:
   for node in tiles.values():node.queue_free()
   tiles.clear();field_signature=fs
  pending.clear();desired.clear()
  var half:Vector2=get_viewport_rect().size/zoom/2.+Vector2.ONE*80.
  var low:Vector2i=Vector2i(((world.player.position-half)/TILE).floor());var high:Vector2i=Vector2i(((world.player.position+half)/TILE).floor())
  for x in range(low.x,high.x+1):
   for y in range(low.y,high.y+1):
    var c:=Vector2i(x,y);var bounds:=Rect2(Vector2(c)*TILE,Vector2.ONE*TILE)
    for f in descriptors:
     if (f.rect as Rect2).grow(150.).intersects(bounds):desired[c]=true;break
  for old in tiles.keys():
   if not desired.has(old):tiles[old].queue_free();tiles.erase(old)
  for c in desired:
   if not tiles.has(c):pending.append(c)
  pending.sort_custom(func(a,b):return a.distance_squared_to(center)<b.distance_squared_to(center))
 # At most one512px tile is generated per rendered frame, no full-field scan.
 if not pending.is_empty():
  var c:Vector2i=pending.pop_front();var start:int=Time.get_ticks_usec();var node:Node2D=_tile(c);tile_build_usec=maxi(tile_build_usec,Time.get_ticks_usec()-start);add_child(node);tiles[c]=node
 _remote_tick()
func _tile(c:Vector2i)->Node2D:
 var root:=Node2D.new();root.position=Vector2(c)*TILE;var bounds:=Rect2(root.position,Vector2.ONE*TILE)
 var ridges:Array=WorldTerrain103.ridges_for_chunk(SaveData.world_seed,WorldMap.chunk_at(root.position))
 var surface=world._get_surface98()
 var edited:Array=[]
 for edit in SaveData.world_edits:
  if edit.get("pos") is Vector2 and bounds.grow(90).has_point(edit.pos):edited.append(edit.pos)
 for field in descriptors:
  if not (field.rect as Rect2).grow(150.).intersects(bounds):continue
  var polygon:PackedVector2Array=FloristJourney138.boundary(field);var rng=RandomNumberGenerator.new();rng.seed=hash(str(field.seed)+str(c))
  var points:Array=[]
  var step:int=29 if not field.planted else 28
  for x in range(0,TILE,step):
   for y in range(0,TILE,step):
    var jitter:Vector2=Vector2(rng.randf_range(0,step-1),rng.randf_range(0,step-1)) if not field.planted else Vector2(12,12)
    var pos:Vector2=root.position+Vector2(x,y)+jitter
    var h:float=rng.randf_range(24,32)
    if not Geometry2D.is_point_in_polygon(pos,polygon):continue
    if surface.contains(pos,30.):continue
    var blocked:bool=false
    for ridge in ridges:
     if (ridge.box as Rect2).grow(20).has_point(pos):blocked=true;break
    if blocked or _reserved(pos,edited):continue
    points.append([pos-root.position,h])
  if points.is_empty():continue
  var tex:Texture2D=RegionalFlowerField123.FLOWERS["red1" if field.species=="red" else "violet"]
  var mesh:=QuadMesh.new();mesh.size=Vector2.ONE
  var mm:=MultiMesh.new();mm.transform_format=MultiMesh.TRANSFORM_2D;mm.mesh=mesh;mm.instance_count=points.size()
  for i in points.size():
   var h:float=points[i][1];var w:float=h*tex.get_width()/tex.get_height()
   mm.set_instance_transform_2d(i,Transform2D(Vector2(w,0),Vector2(0,h),points[i][0]-Vector2(0,h/2.)))
  var batch:=MultiMeshInstance2D.new();batch.multimesh=mm;batch.texture=tex;root.add_child(batch);built_flower_count+=points.size()
 return root
func _reserved(pos:Vector2,edited:Array)->bool:
 for point in edited:
  if pos.distance_to(point)<90.:return true
 return false
func refresh()->void:last_signature=0
func _remote_tick()->void:
 var door:Vector2=FloristJourney138.door(SaveData.world_flora138)
 var near:bool=world.player.position.distance_to(door)<1800.
 if near and not is_instance_valid(remote):
  remote=Node2D.new();remote.name="FloristEast138";remote.y_sort_enabled=true;world.add_child(remote)
  var path=load("res://src/Presentation/world_draw_node.gd").new();path.z_index=-5;path.draw_fn=func(n):
   for points in FloristJourney138.lanes(SaveData.world_flora138):ContinuousRoadArt.access(n,points,32.)
  remote.add_child(path)
  var shop:=Sprite2D.new();shop.texture=WorldFloristShop.SHOP;shop.position=door+Vector2(-20,2);shop.scale=Vector2.ONE*200./shop.texture.get_height();shop.offset=Vector2(0,-shop.texture.get_height()/2.);remote.add_child(shop)
  WorldPhysics.add_box(remote,Rect2(door+Vector2(-130,-113),Vector2(235,85)))
  var npc:=Sprite2D.new();npc.texture=WorldFloristShop.FLORIST;npc.position=door+Vector2(110,32);npc.scale=Vector2.ONE*92./npc.texture.get_height();npc.offset=Vector2(0,-npc.texture.get_height()/2.);remote.add_child(npc)
  var label:=Label.new();label.text="Floristería del Camino del Este";label.position=door+Vector2(-150,-238);label.add_theme_font_size_override("font_size",20);remote.add_child(label)
  for side in [-1,1]:
   var home:=Sprite2D.new();home.texture=WorldTestZone.HOUSE_TEX;home.position=door+Vector2(side*550,-110);home.scale=Vector2.ONE*116./home.texture.get_height();home.offset=Vector2(0,-home.texture.get_height()/2.);remote.add_child(home)
   WorldPhysics.add_box(remote,Rect2(home.position+Vector2(-58,-50),Vector2(116,30)))
  _make_gardens(remote,door)
 if not near and is_instance_valid(remote):remote.queue_free();remote=null
func _make_gardens(parent:Node2D,door:Vector2)->void:
 if not is_instance_valid(parent):return
 for side in [-1,1]:
  var rect:=Rect2(door+Vector2(-300 if side<0 else 180,-30 if parent==remote else 0),Vector2(120,100))
  var valid:bool=true
  for edit in SaveData.world_edits:
   if edit.get("pos") is Vector2 and rect.grow(80).has_point(edit.pos):valid=false
  if not valid:continue
  # Existing path access stays open down the middle. Gate opens on south edge.
  WorldFence.segment(parent,rect.position,Vector2(rect.end.x,rect.position.y))
  WorldFence.segment(parent,rect.position,Vector2(rect.position.x,rect.end.y))
  WorldFence.segment(parent,Vector2(rect.end.x,rect.position.y),rect.end)
  WorldFence.segment(parent,Vector2(rect.position.x,rect.end.y),Vector2(rect.get_center().x-24,rect.end.y))
  WorldFence.segment(parent,Vector2(rect.get_center().x+24,rect.end.y),rect.end)
  var flowers:=RegionalFlowerField123.new();flowers.position=Vector2.ZERO
  for x in 4:
   for y in 3:flowers.flowers.append({"pos":rect.position+Vector2(18+x*27,24+y*25),"height":24.,"type":("blue1" if side<0 else "sun1") if parent==gardens else ("red1" if side<0 else "violet")})
  parent.add_child(flowers)
static func reserve(state:Dictionary,pos:Vector2)->bool:
 if state.is_empty():return false
 var door:Vector2=FloristJourney138.door(state)
 for species in FloristJourney138.SPECIES:
  if pos.distance_to(FloristJourney138.sample_point(state,species))<85.:return true
 # Clear the actual walkable spur from the existing east-west trunk to the shop.
 return Rect2(door+Vector2(-700,-340),Vector2(1400,560)).has_point(pos) or FloristJourney138.on_lane(state,pos,55.)

static func exclude_decor(state:Dictionary,seed_:int,d:Dictionary)->bool:
 if state.is_empty() or d.get("edited",false) or d.kind not in ["flower","tree","pine","fruit_tree"]:return false
 for field in FloristJourney138.descriptors(state,seed_):
  if field.planted or not (field.rect as Rect2).grow(150).has_point(d.pos):continue
  if Geometry2D.is_point_in_polygon(d.pos,FloristJourney138.boundary(field)):
   return d.kind=="flower" or posmod(hash(str(seed_)+str(d.pos)+"sparse138"),5)!=0
 return false
