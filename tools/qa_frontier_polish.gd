extends Node
var world
func _ready():run.call_deferred()
func shot(path:String):
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png(path)
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa-frontier-polish.cfg";SaveData.trial_session_active=false;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();GameState.brand_intro_played=true;SaveData.world_quests={};SaveData.world_seed=752026;SaveData.world_position=Vector2(220,350)
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu)
 await get_tree().create_timer(.8).timeout
 var curtain=FrontierTransition.obtain(get_tree(),false)
 var fade=curtain.create_tween();fade.tween_property(curtain.curtain,"modulate:a",1.0,.22);await fade.finished
 await curtain._warm_showcase()
 world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world);menu.queue_free()
 await shot("/downloads/frontier-transition.png")
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(.6).timeout
 await shot("/downloads/frontier-paths.png");await get_tree().create_timer(2).timeout
 world.player.set_physics_process(false)
 for i in 180:
  world.player.position+=Vector2(5.0,0);world.player.velocity=Vector2(300,0)
  await get_tree().process_frame
 await shot("/downloads/frontier-streaming.png")
 await get_tree().create_timer(.8).timeout;get_tree().quit()
