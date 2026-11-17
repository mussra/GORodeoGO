extends Node2D
## Complete low-detail terrain/contour, using the exact town plan and material.
## No new chunks, actors, colliders, discovery, rewards or simulation are created.
var plan:Dictionary
var world:Node
var ground:Node2D
var walls:Node2D
var overview246:bool=false
var _cell246:Vector2i=Vector2i(999999,999999)
var _bounds246:Rect2
var _plans246:Array=[]
var roads246:Array=[]
func _ready()->void:
 if overview246:_refresh246()
 ground=Node2D.new();ground.z_index=-9;ground.texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED;add_child(ground)
 ground.draw.connect(_ground)
 walls=Node2D.new();walls.z_index=-6;walls.texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED;add_child(walls)
 walls.draw.connect(_walls)
func _ground()->void:
 var box:Rect2=_bounds246.grow(1024.) if overview246 else (plan.bounds as Rect2).grow(7000.)
 var points:=PackedVector2Array([box.position,Vector2(box.end.x,box.position.y),box.end,Vector2(box.position.x,box.end.y)])
 var uv:=PackedVector2Array()
 for point in points:uv.append(WorldGrassTexture.uv_at(SaveData.world_seed,point))
 ground.draw_polygon(points,PackedColorArray([Color.WHITE]),uv,WorldGrassTexture.CACHE)
func _walls()->void:
 if overview246:
  if get_viewport().get_camera_2d().zoom.x>=.7:return
  for route in roads246:walls.draw_polyline(route,Color("c39b65"),40.)
  for item in _plans246:_wall246(item)
 else:_wall246(plan)
func _wall246(item:Dictionary)->void:
 var shape:Dictionary=TownWallArt242.geometry(item)
 var look:Dictionary=TownIdentity215.look(SaveData.world_cousins140,item.id)
 for polygon in shape.outer:walls.draw_colored_polygon(polygon,Color('514537'))
 for polygon in shape.surface:walls.draw_colored_polygon(polygon,Color('ead7aa'))
 for polygon in shape.inset:
  var uv:=PackedVector2Array()
  for point in polygon:uv.append(point/128.)
  walls.draw_polygon(polygon,PackedColorArray([Color.WHITE]),uv,TownPaint215.texture(look))

func _refresh246()->void:
 var camera_:Camera2D=get_viewport().get_camera_2d()
 var center:Vector2=world.player.global_position
 var extent:Vector2=get_viewport_rect().size/(camera_.zoom if camera_!=null else Vector2.ONE)
 _bounds246=Rect2(center-extent*.5,extent).grow(1024.)
 _plans246=[];roads246=[]
 var all:Dictionary=TownEnclosures227.plans(SaveData.world_seed) if SaveData.world_generator_version>=4 else {}
 var routes_:Array=[]
 for item in all.values():
  if (item.bounds as Rect2).grow(80.).intersects(_bounds246):_plans246.append(item)
  routes_.append(item.road)
 if SaveData.world_generator_version>=6:routes_.append_array(TownNetwork234.roads(SaveData.world_seed,all))
 var clip_:PackedVector2Array=PackedVector2Array([_bounds246.position,Vector2(_bounds246.end.x,_bounds246.position.y),_bounds246.end,Vector2(_bounds246.position.x,_bounds246.end.y)])
 for route in routes_:
  for part in Geometry2D.intersect_polyline_with_polygon(route,clip_):roads246.append(part)
func _process(_delta:float)->void:
 if not overview246:return
 var cell_:Vector2i=Vector2i((world.player.position/256.).floor())
 var zoom_:float=get_viewport().get_camera_2d().zoom.x
 if cell_==_cell246 and get_meta('zoom246',0.)==zoom_:return
 _cell246=cell_;set_meta('zoom246',zoom_);_refresh246()
 if is_instance_valid(ground):ground.queue_redraw()
 if is_instance_valid(walls):walls.queue_redraw()
