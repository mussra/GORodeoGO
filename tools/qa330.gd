extends Node
func _ready():run.call_deferred()
func shot330(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/capture330-'+name_+'.png')
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.performance_osd245=false;GameState.brand_intro_played=true;SaveData.story_intro319=true;GameState.controls_world323=false;SaveData.save_path='user://qa330-'+str(Time.get_ticks_usec())+'.cfg';SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_generator_version=3;SaveData.world_seed=752026;SaveData.world_position=WorldNominal98.home();SaveData.world_edits=[];SaveData.world_pig_captures=[];SaveData.world_pigs=[]
 var world=load('res://src/Presentation/frontier_world.gd').new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 while get_tree().root.get_node_or_null('FrontierTransition')!=null:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var pig=world._lasso_pigs()[0];pig.position=world.player.position+Vector2(150,0);world._on_lasso_prey_captured(pig);pig.set_process(false);pig.state.run=AnimalFatigue.RUN_SECONDS-.001;SaveData._load_valid=false
 world._tick_pigs(.01);await get_tree().create_timer(.1).timeout;await shot330('failure-no-bell')
 SaveData._load_valid=true;world._on_lasso_prey_captured(pig);world._tick_pigs(.01)
 await get_tree().create_timer(.1).timeout;await shot330('retry-captured');world.free()
 var cfg=ConfigFile.new();cfg.set_value('progress','highest_level_completed',1);cfg.set_value('horses_trial','state',{'invalid':true});cfg.save(SaveData.save_path);SaveData._load_valid=false
 var menu=load('res://src/Presentation/main_menu.tscn').instantiate();add_child(menu);await get_tree().create_timer(.5).timeout;menu._show_settings();await get_tree().create_timer(.2).timeout
 var button=menu.find_child('SaveDiagnostic330',true,false);button.pressed.emit();await get_tree().create_timer(.2).timeout;await shot330('diagnostic');menu.free();get_tree().quit()
