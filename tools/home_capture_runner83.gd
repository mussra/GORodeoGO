extends Node
func _ready():run.call_deferred()
func shot(path:String):
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png(path)
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://home-preview83.cfg";SaveData.trial_session_active=false;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();GameState.brand_intro_played=true;SaveData.world_quests={};SaveData.world_seed=752026;SaveData.world_position=Vector2(14000,160)
 get_tree().change_scene_to_file("res://src/Presentation/main_menu.tscn")
 await get_tree().create_timer(1.1).timeout
 await shot("/downloads/frontier-entry-menu.png")
 var start=Time.get_ticks_usec();get_tree().current_scene._world_button.pressed.emit()
 await get_tree().create_timer(.4).timeout;await shot("/downloads/frontier-entry-covered.png")
 while get_tree().current_scene==null or get_tree().current_scene.get_script().resource_path!="res://src/Presentation/frontier_world.gd" or get_tree().current_scene._loading_world:await get_tree().process_frame
 print("ACTUAL_ENTRY menu_to_world_ms=",(Time.get_ticks_usec()-start)/1000.0)
 await get_tree().create_timer(.6).timeout
 print("ACTUAL_ENTRY curtain_removed=",get_tree().root.get_node_or_null("FrontierTransition")==null," chunks=",get_tree().current_scene._chunks.size())
 await shot("/downloads/home-before83.png")
 await get_tree().create_timer(.6).timeout
 var world=get_tree().current_scene;world._home()
 await get_tree().create_timer(.4).timeout
 while world._loading_world or world._returning_home or get_tree().root.get_node_or_null("FrontierTransition")!=null:await get_tree().process_frame
 print("HOME83 final=",world.player.position," loading=",world._loading_world," chunks=",world._chunks.size())
 await shot("/downloads/home-after83.png");await get_tree().create_timer(.8).timeout;get_tree().quit()
