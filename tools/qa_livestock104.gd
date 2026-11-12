extends Node
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/cerdos104-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(1598,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa104.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home();SaveData.world_pig_captures.clear();SaveData.world_goat_captures.clear();SaveData.world_pigs_sold=0;SaveData.equipment_points=0
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.).timeout
 world.player.set_physics_process(false);world.player.velocity=Vector2.ZERO
 NpcQuests.accept(SaveData.world_quests,"farmer_pigs")
 for i in 3:SaveData.record_pig104("qa104:pig%d"%i)
 world._toasts.clear();world._refresh_livestock104();world._toast(tr("WORLD_PIG_CAPTURE104") % [3,3,40]);await shot("captura")
 world._open_npc(world._npcs98()[0]);await shot("precio-antes")
 world._toasts.clear();world._npc_dialog.get_node("SellPigs104").pressed.emit()
 await shot("venta")
 print("LIVESTOCK104 after_sale inventory=",SaveData.pig_inventory104()," captured=",SaveData.world_pig_captures.size()," sold=",SaveData.world_pigs_sold," points=",SaveData.equipment_points)
 get_tree().quit()
