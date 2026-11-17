extends Node
func _ready():run.call_deferred()
func run():
 var phase:String=OS.get_environment('PIG_PHASE');if phase.is_empty():phase='after'
 get_tree().root.size=Vector2i(1280,720);Engine.max_fps=60;SaveData.world_generator_version=6;SaveData.world_seed=752026
 var host=load('res://tools/horse248_host.gd').new();add_child(host);host.y_sort_enabled=true
 var chosen:Dictionary={};var segment:Dictionary={}
 for p in TownEnclosures227.plans(752026).values():
  for s in p.segments:
   if absf(s.b.x-s.a.x)<1. and absf(s.b.y-s.a.y)>500.:chosen=p;segment=s;break
  if not chosen.is_empty():break
 host.plan=chosen;host.queue_redraw()
 var middle:Vector2=(segment.a+segment.b)*.5;var normal:Vector2=(segment.b-segment.a).normalized().orthogonal()
 if WorldTerrain103.blocked(752026,middle+normal*60.,18.):normal=-normal
 var start:Vector2=middle+normal*58.;var tangent:Vector2=normal.orthogonal()
 var camera:=Camera2D.new();camera.position=start+normal*220.;host.add_child(camera)
 var floor_:=ColorRect.new();floor_.position=camera.position-Vector2(3000,3000);floor_.size=Vector2(6000,6000);floor_.color=Color('759e48');floor_.z_index=-10;host.add_child(floor_)
 var pig=load('res://tools/pig_before249.gd' if phase=='before' else 'res://src/Presentation/wild_pig.gd').new();pig.setup({'pos':start});host.add_child(pig);pig.state.flee=true
 var hud:=CanvasLayer.new();add_child(hud);var text:=Label.new();text.text='Cerdo frente a muro real · '+('ANTES 2.7.178' if phase=='before' else 'DESPUÉS 2.7.179');text.position=Vector2(24,24);text.add_theme_font_size_override('font_size',28);hud.add_child(text)
 var changes:int=0;var last:bool=pig.flip_h;var crossed:int=0;var length_:float=0.;var previous:Vector2=pig.position
 DirAccess.make_dir_recursive_absolute('/downloads/pig249-'+phase)
 for i in 180:
  pig.flee_from(pig.position+normal*100.+tangent*(1. if i%2==0 else -1.),1./60.,225.)
  length_+=previous.distance_to(pig.position);previous=pig.position
  if pig.flip_h!=last:changes+=1;last=pig.flip_h
  if WorldTerrain103.blocked(752026,pig.position,18.):crossed+=1
  await get_tree().process_frame;await RenderingServer.frame_post_draw
  if i%3==0:get_viewport().get_texture().get_image().save_png('/downloads/pig249-'+phase+'/frame-%03d.png'%(i/3))
 get_viewport().get_texture().get_image().save_png('/downloads/pig249-'+phase+'.png')
 var f:=FileAccess.open('/downloads/pig249-'+phase+'.json',FileAccess.WRITE);f.store_string(JSON.stringify({'net_distance':pig.position.distance_to(start),'path_length':length_,'sprite_flips':changes,'wall_crossings':crossed,'steps':180,'hz':60},'  '));f.close()
 host.free();await get_tree().process_frame;get_tree().quit()
