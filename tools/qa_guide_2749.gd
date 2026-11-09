extends Node
func _ready()->void:call_deferred("run")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.world_seed=424242;SaveData.world_tamed.clear();SaveData.world_discovered.clear();SaveData.horse_collection.seed_trial()
 var c:=Vector2i(5,1);var herd:Dictionary=WorldMap.generate(424242,c.x,c.y).herd
 SaveData.world_position=herd.pos+Vector2(0,90)
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 var group:Array=[]
 for cycle in range(200):
  await get_tree().create_timer(.1).timeout
  group=world._herd_horses.values().filter(func(h):return is_instance_valid(h) and h.get_meta("c")==c)
  if group.size()>=3:break
 world.set_process(false);world.player.set_physics_process(false)
 for horse in group:horse.set_physics_process(false);horse.touch_grace=100.0
 var overlay:=CanvasLayer.new();overlay.layer=40;add_child(overlay)
 var label:=Label.new();label.position=Vector2(150,600);label.add_theme_font_size_override("font_size",23);overlay.add_child(label)
 for frame in range(72):
  if frame==24:
   group[0].roped=true;group[0].rider=world.player;group[0].held=20.0
  var guide:Node2D=group[0] if frame<24 else group[1]
  world.player.position=guide.position+Vector2(-90,0)
  world.player.velocity=Vector2(200,0)
  label.text="GUÍA 1 · grupo unido (radio280px)" if frame<24 else "GUÍA 1 ENLAZADO · guía 2 toma el relevo"
  for tick in range(5):
   if group[0].roped:group[0].state.progress=0.0
   world._tick_taming(1.0/60.0)
   for horse in group:horse._physics_process(1.0/60.0)
  await get_tree().create_timer(1.0/12.0).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/guide2749-%02d.png"%frame)
 get_tree().quit()
