extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/mapa108-"+("telefono-" if OS.get_environment("MAP106_SMALL")=="1" else "")+name_+".png")
func run():
 get_tree().root.size=Vector2i(896,414) if OS.get_environment("MAP106_SMALL")=="1" else Vector2i(1598,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa106.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_notes106={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.).timeout
 world.player.set_physics_process(false);world.player.velocity=Vector2.ZERO;world._toasts.clear();world._toasts.visible=false
 var horse:Node2D=null
 for item in world._herd_horses.values():
  if is_instance_valid(item):horse=item;break
 if horse!=null:
  world.player.position=horse.position+Vector2(80,80)
  await get_tree().create_timer(.3).timeout
  world._map_notes159.photo=get_viewport().get_texture().get_image()
 world._toggle_map();world._map_overlay._layout();world._map_overlay._ensure_terrain();world.player.position=WorldNominal98.home()
 var map=world._map_overlay
 map._find_player108();await shot("centrado")
 await get_tree().create_timer(1.).timeout;await shot("aura")
 SaveData.world_discovered.clear()
 for x in range(100):
  for y in range(100):SaveData.world_discovered.append(WorldMap.chunk_key(x,y))
 map._terrain_valid=false
 var start:int=Time.get_ticks_usec();map._ensure_terrain();await get_tree().process_frame;await RenderingServer.frame_post_draw
 print("MAP106 10000 first_render_ms=",(Time.get_ticks_usec()-start)/1000.," builds=",map.terrain_rebuilds)
 await shot("10000")
 map._set_zoom(8.);await get_tree().process_frame;await RenderingServer.frame_post_draw
 var builds:int=map.terrain_rebuilds;start=Time.get_ticks_usec();map._begin_drag106(Vector2(300,200))
 for i in 120:map._drag106(Vector2(300+i*.5,200+i*.25))
 print("MAP106 drag120_cpu_ms=",(Time.get_ticks_usec()-start)/1000.," rebuilds=",map.terrain_rebuilds-builds)
 map._end_drag106(Vector2(360,230));map._find_player108();await shot("zoom")
 get_tree().quit()
