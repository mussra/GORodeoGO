extends Node
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/flores105-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(1598,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa105.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.).timeout
 world.player.set_physics_process(false);world.player.velocity=Vector2.ZERO
 var florist=world._npcs98()[1];world.player.position=florist.position
 await get_tree().create_timer(.2).timeout
 world._toasts.clear();world._open_npc(florist);await shot("encargo")
 world._npc_dialog.accepted.emit("florist_blue105");world.player.set_physics_process(false)
 world._quests_expanded=true;world._quest_panel.visible=true
 world.player.position=WorldFlowers105.positions(752026,3,ModularWorldLayout93.world(WorldNominal98.doors().florist),"florist_blue105")[0]+Vector2(-70,0)
 for i in 30:await get_tree().process_frame
 world._toasts.clear();await shot("aura-hud")
 world.player.position+=Vector2(70,0)
 for i in 3:await get_tree().process_frame
 world._toasts.clear();world._toast("Flor recogida al pasar por encima · 1/3");await shot("recogida")
 get_tree().quit()
