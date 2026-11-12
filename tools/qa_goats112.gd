extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/cabras112-"+("telefono-" if OS.get_environment("MAP106_SMALL")=="1" else "")+name_+".png")
func run():
 get_tree().root.size=Vector2i(896,414) if OS.get_environment("MAP106_SMALL")=="1" else Vector2i(1598,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa106.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_notes106={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.).timeout
 world.player.set_physics_process(false);world.player.velocity=Vector2.ZERO;world._toasts.clear();world._toasts.visible=false
 world.set_process(false);world.set_physics_process(false)
 var goat=world._prototype_goats.get_child(0)
 world.player.position=goat.position-Vector2(150,0);world.player.velocity=Vector2.ZERO
 world._tick_taming(.01);world._tick_goats(.1);await shot("grupo")
 world.player.velocity=Vector2.RIGHT*260.
 for tick in 12:world._tick_goats(.1)
 await shot("huida")
 get_tree().quit()
