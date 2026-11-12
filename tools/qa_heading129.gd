extends Node
var world:Node2D
var label:Label
func _ready():run.call_deferred()
func shot(name_:String,text:String):
 label.text=text
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/lazo128-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa128.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false);world.player.velocity=Vector2.ZERO;world.set_physics_process(false);world.set_process(false)
 for item in world._herd_horses.values():item.free()
 world._herd_horses.clear();world.player.position=WorldNominal98.home()+Vector2(0,500)
 var layer=CanvasLayer.new();layer.layer=100;add_child(layer);var panel=ColorRect.new();panel.color=Color(0,0,0,.8);panel.size=Vector2(1280,100);layer.add_child(panel)
 label=Label.new();label.position=Vector2(24,14);label.add_theme_font_size_override("font_size",25);layer.add_child(label)
 var group:Array=[]
 for i in 4:
  var h=world.WildHorseScript.new();h.setup({"pos":world.player.position+Vector2(180+i*48,(-1 if i%2==0 else 1)*60),"member_id":"qa128#"+str(i),"member_index":i,"traits":{"coat":3+i,"mane":1,"pattern":i},"temperament":.2,"stats":{"speed":260}});h.set_meta("c",Vector2i(99,99));world.add_child(h);h.set_physics_process(false);h.player_ref=world.player;group.append(h);world._herd_horses[h.herd.member_id]=h
 await get_tree().create_timer(.5).timeout
 var last:Array=[];var counts:Array=[0,0,0,0]
 for i in 4:last.append("")
 for frame_ in 150:
  var t:float=frame_/25.
  var angle:float=t*1.1
  # Pursuer swings across axes and diagonals, including a sudden switch of side.
  if t>3.:angle+=PI
  for i in group.size():
   var h=group[i]
   var threat=h.position-Vector2.from_angle(angle+i*.08)*170.
   h.set_meta("escape_left110",6.)
   h.flee_from(threat,.04);h._physics_process(.04)
   var pose=h._art.walk_dir+str(h._art.flip_h)
   if not last[i].is_empty() and pose!=last[i]:counts[i]+=1
   last[i]=pose
  world.player.position=group[0].position-Vector2.from_angle(angle)*170.
  world._update_chunks()
  while not world._build_queue.is_empty():world._drain_chunk_builds()
  label.text="Persecución: giro continuo y vistas estables\nSimulación de escritorio · sin Android físico · %.1f s"%t
  await get_tree().process_frame;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/giro129-%03d.png"%frame_)
 print("VIEWS129 transitions in6s:",counts)
 get_tree().quit()
