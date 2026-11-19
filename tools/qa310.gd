extends Node
var world:Node
func _ready():run.call_deferred()
func wait(s:float):await get_tree().create_timer(s).timeout
func shot(id:String):
 await wait(.4);await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/310-'+id+'.png');print('SHOT310 ',id)
func run():
 get_tree().root.size=Vector2i(1600,900);TranslationServer.set_locale('es');GameState.performance_osd245=false;GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path='user://qa310-isolated.cfg';SaveData._load_valid=true;SaveData.horse_collection.seed_trial();SaveData.trial_session_active=false;SaveData.debug_mode=false;SaveData.highest_level_completed=20;SaveData.rodeo_intro240=true;SaveData.dual_lasso_intro_shown=true
 SaveData.world_seed=0;SaveData.ensure_world_seed();SaveData.world_garden212=Garden212.fresh()
 world=load('res://src/Presentation/frontier_world.tscn').instantiate();add_child(world)
 while world._loading_world:await wait(.2)
 await wait(3.)
 if world._arrival244.active:world._arrival244.finish(false)
 world.player.position=world.garden212.plot+Vector2(0,150)
 for action in ['introduce','accept','sample','plant','water']:
  SaveData.world_garden212=Garden212.action(SaveData.world_garden212,action)
  await shot('huerto-'+action)
 SaveData.world_garden212=Garden212.tick(SaveData.world_garden212,900.,0.);await shot('huerto-ripe')
 world.free();await get_tree().process_frame
 for level in [1,11,40]:
  GameState.selected_level=level;world=load('res://src/Presentation/level_0.tscn').instantiate();add_child(world);await wait(1.);await shot('rodeo-'+str(level));
  if level==11:
   for child in world.get_children():
    if child is PuzzleCorral:child.open_gate()
   await shot('rodeo-11-abierto')
  world.free();await get_tree().process_frame
 get_tree().quit()
