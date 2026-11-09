extends Node
func _ready()->void:call_deferred("run")
func capture(path:String)->void:
 await get_tree().create_timer(.5).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png(path)
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.world_seed=424242;SaveData.world_tamed.clear();SaveData.world_discovered.clear();SaveData.horse_collection.seed_trial()
 var c:=Vector2i.ZERO;var herd:Dictionary={}
 for x in range(1,10):
  herd=WorldMap.generate(424242,x,1).herd
  if not herd.is_empty() and not WorldTaming.is_stallion(herd):c=Vector2i(x,1);break
 SaveData.world_position=herd.pos+Vector2(0,90)
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 var group:Array=[]
 for cycle in range(200):
  await get_tree().create_timer(.1).timeout
  group=world._herd_horses.values().filter(func(h):return is_instance_valid(h) and h.get_meta("c")==c)
  if group.size()>=3:break
 print("QA herd ",c," count=",group.size())
 await capture("/downloads/herd2748-calm.png")
 world.set_process(false);world.player.position=group[0].position+Vector2(-50,0)
 for i in range(12):
  world.player.velocity=Vector2(200,0);world._tick_taming(.016);await get_tree().physics_frame
 await capture("/downloads/herd2748-flee.png")
 get_tree().quit()
