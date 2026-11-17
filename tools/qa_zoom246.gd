extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1600,720)
 TranslationServer.set_locale('es');GameState.sound_enabled=false
 SaveData.save_path='user://qa246-only.dat';SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.world_position=Vector2(1300,850);SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_quests={};SaveData.horse_collection.seed_trial()
 for x in range(-5,15):
  for y in range(-5,15):SaveData.world_discovered.append(WorldMap.chunk_key(x,y))
 var world=load('res://tools/perf_world242.gd').new();add_child(world);get_tree().current_scene=self
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(2.).timeout
 if world._arrival244.active:world._arrival244.finish(false)
 world._arrival244.set_process(false);world.player.set_physics_process(false)
 var result:Array=[]
 for zoom_ in [1.5,1.,.85,.65,.5,.35,.25,1.]:
  world._camera_controls243.set_factor(zoom_,false)
  await get_tree().create_timer(.6).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png('/downloads/zoom246-'+str(zoom_)+'.png')
  result.append({'zoom':zoom_,'chunks':world._chunks.size(),'nodes':Performance.get_monitor(Performance.OBJECT_NODE_COUNT),'calls':Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)})
 GameState.set_performance_osd245(true)
 await get_tree().create_timer(1.).timeout
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png('/downloads/osd246.png')
 GameState.set_performance_osd245(false)
 world._map_overlay._terrain_valid=false;world._map_overlay._ensure_terrain()
 await get_tree().create_timer(.2).timeout
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png('/downloads/minimap246.png')
 world._toggle_map()
 await get_tree().create_timer(.4).timeout
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png('/downloads/map246.png')
 var f=FileAccess.open('/downloads/zoom246.json',FileAccess.WRITE);f.store_string(JSON.stringify(result,'  '));f.close()
 world.free();get_tree().quit()
