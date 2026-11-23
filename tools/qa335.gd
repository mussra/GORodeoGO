extends Node
func _ready():run.call_deferred()
func shot(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/ranch335-'+name_+'.png')
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.performance_osd245=false;GameState.brand_intro_played=true
 var base='user://visual334-'+str(Time.get_ticks_usec());DirAccess.make_dir_absolute(base);SaveData.save_path=base+'/normal.cfg';SaveData.load_progress();SaveData.story_intro319=true;SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.save_progress();SaveData.slots334=SaveSlots334.new();SaveData.slots334.root=base+'/slots';SaveData.slots334.setup(SaveData.save_path,base+'/debug.cfg');SaveData.slots334.attach(SaveData)

 var world=load('res://src/Presentation/frontier_world.gd').new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 while get_tree().root.get_node_or_null('FrontierTransition')!=null:await get_tree().process_frame
 world._travel144.visit_clock=0.;world._travel144.record_visits();world._map_overlay.expanded=true;world._map_overlay._layout();world._map_overlay._ensure_terrain();await get_tree().create_timer(.5).timeout;await shot('map')
 world._travel144.choose('ranch');await get_tree().create_timer(.2).timeout;await shot('confirmation');get_tree().quit()
