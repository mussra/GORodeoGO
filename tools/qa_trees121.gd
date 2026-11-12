extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/arboles121-"+("telefono-" if OS.get_environment("MAP106_SMALL")=="1" else "")+name_+".png")
func run():
 get_tree().root.size=Vector2i(896,414) if OS.get_environment("MAP106_SMALL")=="1" else Vector2i(1598,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa106.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_notes106={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.).timeout
 world.player.set_physics_process(false);world.player.velocity=Vector2.ZERO;world._toasts.clear();world._toasts.visible=false
 world.player.position=WorldNominal98.home()+Vector2(0,500);world.player.velocity=Vector2.RIGHT*70.
 for item in world._herd_horses.values():item.set_physics_process(false)
 world.set_physics_process(false);world.set_process(false)
 var base:Vector2=world.player.position
 var sample:Array=[]
 for x in range(-400,401,200):
  for y in [100,300]:
   var pos=base+Vector2(x,y)
   var kind=["tree","pine","fruit_tree"][abs(x/200+int(y/100))%3]
   var d=world.DecorScript.new();d.configure121(kind,pos,1.,SaveData.world_seed);world.add_child(d);sample.append([d,pos,kind])
 for state in ["antes","despues"]:
  for row in sample:
   var d=row[0];var sc:float=1. if state=="antes" else world.DecorScript.effective_scale121(row[2],row[1],1.,SaveData.world_seed)
   d.size_scale=sc;d.scale=Vector2.ONE*sc;d.position=row[1]+Vector2(0,20*sc);d.draw_offset=Vector2(0,-20);d.queue_redraw()
  await shot(state)
 # Large tree with rider behind and in front, exact foot sort, dynamic marker.
 sample.sort_custom(func(a,b):return a[0].size_scale>b[0].size_scale)
 var row=sample[0];var d=row[0]
 world.register_occluder("qa121",world.DecorScript.occluder_box(row[2],row[1],d.size_scale))
 for front in [false,true]:
  world.player.position=row[1]+Vector2(0,20*d.size_scale+(35 if front else -50));world._tick_rider_marker()
  await shot("delante" if front else "detras")
 get_tree().quit()
