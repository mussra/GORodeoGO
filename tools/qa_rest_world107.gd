extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/mapa108-"+("telefono-" if OS.get_environment("MAP106_SMALL")=="1" else "")+name_+".png")
func run():
 get_tree().root.size=Vector2i(896,414) if OS.get_environment("MAP106_SMALL")=="1" else Vector2i(1598,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa106.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_notes106={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.).timeout
 world.player.set_physics_process(false);world.player.velocity=Vector2.ZERO;world._toasts.clear();world._toasts.visible=false
 world.player.position=WorldNominal98.home();world.player._sprite_swap.rest107.elapsed=0.
 RiderGaitVisual.apply(world.player._sprite_swap,Vector2.ZERO,270,0,.1)
 await shot("reposo")
 world.player._sprite_swap.rest107.elapsed=world.player._sprite_swap.rest107.wait+1.
 RiderGaitVisual.apply(world.player._sprite_swap,Vector2.ZERO,270,0,.01)
 await shot("gesto")
 RiderGaitVisual.apply(world.player._sprite_swap,Vector2.RIGHT*180,270,1,.1)
 await get_tree().create_timer(.2).timeout;await shot("marcha")
 get_tree().quit()
