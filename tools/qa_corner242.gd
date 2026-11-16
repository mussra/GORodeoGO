extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path='user://corner242-only.cfg';SaveData.trial_session_active=true;SaveData.debug_mode=false;SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.world_position=Vector2(1300,850);SaveData.world_quests={};SaveData.world_discovered=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var plans:Dictionary=TownEnclosures227.plans(752026);var chosen:Array=[];var seen:Dictionary={}
 for plan in plans.values():
  if seen.has(plan.shape):continue
  seen[plan.shape]=true;chosen.append(plan)
 var world=load('res://src/Presentation/frontier_world.tscn').instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false);world.set_physics_process(false)
 var camera:Camera2D=get_viewport().get_camera_2d();camera.position_smoothing_enabled=false
 for plan in chosen:
  world.player.position=plan.polygon[0]+Vector2(0,100);world._update_chunks()
  while not world._build_queue.is_empty():world._step_chunk_build()
  for key in world._chunk_built.keys():world._activate_built(key)
  world.set_process(false)
  await get_tree().create_timer(.4).timeout
  for i in 6:await get_tree().process_frame
  await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png('/downloads/corner242-'+str(plan.shape)+'.png');print('CORNER ',plan.id,' ',plan.shape_name)
  world.set_process(true)
 world.free();get_tree().quit()
