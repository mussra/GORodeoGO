extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path='user://town318-only.cfg';SaveData.world_garden212=Garden212.fresh();SaveData.world_edits=[];SaveData.trial_session_active=true;SaveData.debug_mode=false;SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.world_position=Vector2(1300,850);SaveData.world_quests={};SaveData.world_discovered=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var plans:Dictionary=TownEnclosures227.plans(752026);var chosen:Array=[];var seen:Dictionary={}
 for plan in plans.values():
  if plan.shape not in [0,1,2,3] or seen.has(plan.shape):continue
  seen[plan.shape]=true;chosen.append(plan)
 var world=load('res://src/Presentation/frontier_world.tscn').instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(2.).timeout
 world.player.set_physics_process(false);world.set_physics_process(false)
 var camera:Camera2D=get_viewport().get_camera_2d();camera.position_smoothing_enabled=false;camera.zoom=Vector2.ONE*.9;GameState.performance_osd245=false
 for plan in chosen:
  for direction in plan.gates:
   var entry:Dictionary=plan.gates[direction]
   world.player.position=entry.point-entry.outward*70.;world._update_chunks()
   while not world._build_queue.is_empty():world._step_chunk_build()
   for key in world._chunk_built.keys():world._activate_built(key)
   if world._arrival244.active:world._arrival244.finish(false)
   world.set_process(false)
   world._toasts.clear()
   for layer in world.get_children():
    if layer is CanvasLayer and layer.name.contains("Toast"):layer.hide()
   await get_tree().create_timer(.4).timeout
   for i in 6:await get_tree().process_frame
   await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png('/downloads/town318-'+str(plan.shape)+'-'+direction+'.png');print('GATE ',plan.id,' ',plan.shape_name,' ',direction,' ',entry.posts)
   world.set_process(true)
 world.free();get_tree().quit()
