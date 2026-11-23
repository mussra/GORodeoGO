extends Node
func _ready():run.call_deferred()
func shot(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/food335-'+name_+'.png')
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.performance_osd245=false;GameState.brand_intro_played=true
 var base='user://visual334-'+str(Time.get_ticks_usec());DirAccess.make_dir_absolute(base);SaveData.save_path=base+'/normal.cfg';SaveData.load_progress();SaveData.story_intro319=true;SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.save_progress();SaveData.slots334=SaveSlots334.new();SaveData.slots334.root=base+'/slots';SaveData.slots334.setup(SaveData.save_path,base+'/debug.cfg');SaveData.slots334.attach(SaveData)

 var world=load('res://src/Presentation/frontier_world.gd').new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 while get_tree().root.get_node_or_null('FrontierTransition')!=null:await get_tree().process_frame

 world._arrival244.finish(false);world._camera_controls243.set_factor(1.,false,false);SaveData.world_garden212.stage='search';world.player.position=world.garden212.sample+Vector2(100,0);world._camera_controls243.set_process(false);world.get_viewport().get_camera_2d().zoom=Vector2.ONE;world.get_viewport().get_camera_2d().position_smoothing_enabled=false;await get_tree().create_timer(.6).timeout;await shot('sample')
 SaveData.world_garden212.stage='empty';SaveData.world_garden212.crops=3;SaveData.world_garden212.discovered=true;world.garden212.open();await get_tree().create_timer(6.).timeout;await shot('feed-menu')
 var before=SaveData.world_garden212.crops;world.garden212.act('feed');print('FEED335 ',{'before':before,'after':SaveData.world_garden212.crops,'food':SaveData.world_garden212.food,'multiplier':Garden212.multiplier(SaveData.world_garden212,SaveData.horse_collection.selected)})
 await get_tree().create_timer(1.).timeout;await shot('feed-active');get_tree().quit()
