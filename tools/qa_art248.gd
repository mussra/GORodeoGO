extends Node2D
var phase:String='after'
var paint:Node2D
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1600,720);SaveData.world_generator_version=6;SaveData.world_seed=752026
 var camera:=Camera2D.new();camera.position=Vector2(800,360);add_child(camera)
 var floor_:=ColorRect.new();floor_.position=Vector2(-2000,-2000);floor_.size=Vector2(6000,6000);floor_.color=Color('6a9944');floor_.z_index=-10;add_child(floor_)
 var roots:=Node2D.new();roots.y_sort_enabled=true;add_child(roots)
 var container:=Node2D.new();container.name='prototype_goats';container.y_sort_enabled=phase=='after';roots.add_child(container)
 var decor=load('res://src/Presentation/world_decor.gd').new();decor.kind='pine';decor.position=Vector2(240,-30);decor.size_scale=3.3;roots.add_child(decor)
 # Camera depth case is shifted into view without changing relative Y around 0.
 roots.position=Vector2(0,385)
 for point_ in [Vector2(232,-100),Vector2(280,-12)]:
  var goat=load('res://src/Presentation/wild_goat.gd').new();goat.setup({'pos':point_});container.add_child(goat);goat.set_process(false)
 var caption:=Label.new();caption.text='Cabra detras / cabra delante';caption.position=Vector2(80,450);caption.add_theme_font_size_override('font_size',22);add_child(caption)
 paint=Node2D.new();paint.texture_repeat=CanvasItem.TEXTURE_REPEAT_MIRROR;add_child(paint);paint.draw.connect(_walls)
 var title:=Label.new();title.text='Cebra: esquina, diagonal y borde entre sectores';title.position=Vector2(550,10);title.add_theme_font_size_override('font_size',25);add_child(title)
 await get_tree().create_timer(1.).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/art248-'+phase+'.png')
 var times:Array=[]
 for i in 160:
  var start:int=Time.get_ticks_usec();await get_tree().process_frame
  if i>20:times.append((Time.get_ticks_usec()-start)/1000.)
 var sum_:float=0.
 for t in times:sum_+=t
 times.sort()
 var f=FileAccess.open('/downloads/art248-'+phase+'.json',FileAccess.WRITE);f.store_string(JSON.stringify({'mean':sum_/times.size(),'p95':times[int(times.size()*.95)],'calls':Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),'nodes':Performance.get_monitor(Performance.OBJECT_NODE_COUNT)},'  '));f.close();get_tree().quit()
func _walls():
 var plan:Dictionary={'segments':[{'a':Vector2(680,80),'b':Vector2(720,340)},{'a':Vector2(720,340),'b':Vector2(1450,220)}]}
 var g:=TownWallArt242.geometry(plan);var look:Dictionary={'base':'ead7aa','spot':'4b9b77','pattern':9}
 for p in g.outer:paint.draw_colored_polygon(p,Color('514537'))
 for p in g.surface:paint.draw_colored_polygon(p,Color('ead7aa'))
 for p in g.inset:
  for bounds_ in [Rect2(0,0,1024,1024),Rect2(1024,0,1024,1024)]:
   var clip:=PackedVector2Array([bounds_.position,Vector2(bounds_.end.x,bounds_.position.y),bounds_.end,Vector2(bounds_.position.x,bounds_.end.y)])
   for part in Geometry2D.intersect_polygons(p,clip):
    var uv:=PackedVector2Array()
    for v in part:uv.append(v/128.)
    paint.draw_polygon(part,PackedColorArray([Color.WHITE]),uv,TownPaint215.texture(look))
