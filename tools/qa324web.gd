extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true;SaveData.save_path='user://qa324-web-only.cfg';SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.debug_mode=false;SaveData.story_intro319=true;SaveData.dual_lasso_intro_shown=true
 GameState.selected_level=5;SaveData.trial_session_active=true
 var level=load('res://src/Presentation/level_0.tscn').instantiate();add_child(level)
 await get_tree().create_timer(.5).timeout;level.player.position+=Vector2(-80,70);level.player.set_physics_process(false);await get_tree().create_timer(.5).timeout;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png('/downloads/web324-rodeo.png');level.free()
 SaveData.trial_session_active=false;SaveData.world_quests={};SaveData.country_ledger146={};SaveData.world_generator_version=3;SaveData.world_seed=752026;SaveData.world_position=WorldNominal98.home()+Vector2(-200,240);GameState.controls_world323=true
 var world=load('res://src/Presentation/frontier_world.tscn').instantiate();add_child(world)
 await get_tree().create_timer(10.).timeout
 for child in world.get_children():
  if child is TutorialGuide323:child.close323()
 await get_tree().create_timer(.5).timeout;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png('/downloads/web324-frontera.png');world.free();get_tree().quit()
