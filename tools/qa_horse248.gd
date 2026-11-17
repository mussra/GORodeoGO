extends Node
func _ready():run.call_deferred()
func run():
 var phase:String=OS.get_environment('ART_PHASE');if phase.is_empty():phase='before'
 get_tree().root.size=Vector2i(1280,720);Engine.max_fps=60;SaveData.world_generator_version=6;SaveData.world_seed=752026
 var host=load('res://tools/horse248_host.gd').new();add_child(host);host.y_sort_enabled=true
 var chosen:Dictionary={};var segment:Dictionary={}
 for p in TownEnclosures227.plans(752026).values():
  for s in p.segments:
   if absf(s.b.x-s.a.x)>500. and absf(s.b.y-s.a.y)>500.:chosen=p;segment=s;break
  if not chosen.is_empty():break
 host.plan=chosen;host.queue_redraw()
 var middle:Vector2=(segment.a+segment.b)*.5;var normal:Vector2=(segment.b-segment.a).normalized().orthogonal()
 if WorldTerrain103.blocked(752026,middle+normal*60.,18.):normal=-normal
 var start:Vector2=middle+normal*58.
 var camera:=Camera2D.new();camera.position=start+normal*190.;host.add_child(camera)
 var floor_:=ColorRect.new();floor_.position=camera.position-Vector2(3000,3000);floor_.size=Vector2(6000,6000);floor_.color=Color('759e48');floor_.z_index=-10;host.add_child(floor_)
 var horse=load('res://src/Presentation/wild_horse.gd').new();horse.setup({'pos':start,'traits':{'coat':3,'mane':0,'pattern':9}});host.add_child(horse);horse.set_physics_process(false);horse.set_meta('escape_left110',100.)
 var slider=load('res://src/Presentation/wild_horse.gd').new();slider.setup({'pos':start+normal*280.,'traits':{'coat':1,'mane':0,'pattern':9}});host.add_child(slider);slider.set_physics_process(false)
 var player:=Node2D.new();host.add_child(player);slider.player_ref=player;player.position=slider.position+Vector2(2000,0);slider._physics_process(.016);player.position=slider.position-Vector2(150,0)
 var text:=Label.new();text.text='Muro diagonal: huida tangente / volver tras pausa lejana';text.position=Vector2(20,20);text.add_theme_font_size_override('font_size',24);var hud:=CanvasLayer.new();add_child(hud);hud.add_child(text)
 var origin:Vector2=horse.position;var slider_origin:Vector2=slider.position;var last:int=slider._art.frame;var changed:int=0;var times:Array=[];var blocked:int=0
 DirAccess.make_dir_recursive_absolute('/downloads/horse248-'+phase)
 for i in 150:
  var time_:int=Time.get_ticks_usec()
  horse.flee_velocity(-normal*230.);horse._physics_process(1./60.)
  slider.approach(slider.position+Vector2(120,0),1./60.);slider._physics_process(1./60.)
  times.append(Time.get_ticks_usec()-time_)
  if slider._art.frame!=last:changed+=1;last=slider._art.frame
  if WorldTerrain103.blocked(752026,horse.position,18.):blocked+=1
  await get_tree().process_frame;await RenderingServer.frame_post_draw
  if i%3==0:get_viewport().get_texture().get_image().save_png('/downloads/horse248-'+phase+'/frame-%03d.png'%(i/3))
 get_viewport().get_texture().get_image().save_png('/downloads/horse248-'+phase+'.png')
 var sum_:float=0.
 for t in times:sum_+=t
 times.sort()
 var f=FileAccess.open('/downloads/horse248-'+phase+'.json',FileAccess.WRITE);f.store_string(JSON.stringify({'wall_distance':origin.distance_to(horse.position),'slide_distance':slider_origin.distance_to(slider.position),'animation_frame_changes':changed,'animation_speed':slider._art.speed_scale,'wall_crossings':blocked,'cpu_two_horses_mean_us':sum_/times.size(),'cpu_p95_us':times[int(times.size()*.95)]},'  '));f.close();get_tree().quit()
