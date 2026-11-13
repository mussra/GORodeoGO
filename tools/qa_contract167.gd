extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/contract167-"+name_+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://qa-contract167.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_position=WorldNominal98.home();SaveData.world_edits=[];SaveData.world_roaming139={};SaveData.country_ledger146={};SaveData.world_missions={};SaveData.world_quests={};SaveData.world_discovered=[];SaveData.world_places144={};SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_pig_captures=[];SaveData.world_goat_captures=[];SaveData.world_pigs_sold=0;SaveData.repeat_contract165=ProgressionEconomy165.new_contract();SaveData.equipment_points=0;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.2).timeout
 var npc:Dictionary=NpcQuests.NPCS[0].duplicate(true);world.player.position=npc.position;world._open_npc(npc);await shot("farmer")
 world._npc_dialog.get_node("RepeatContracts165").pressed.emit();await get_tree().process_frame
 var panel:RepeatContractsPanel165=world._npc_dialog;assert(panel!=null);assert(not world.player.is_physics_processing());await shot("offer")
 panel.action.pressed.emit();assert(SaveData.repeat_contract165.active);await shot("active")
 for i in 5:assert(SaveData.record_pig104("qa-pig-%d"%i))
 panel.refresh();await shot("ready");var before:int=SaveData.equipment_points;panel.action.pressed.emit();assert(SaveData.equipment_points==before+400);assert(SaveData.repeat_contract165.completed==1);await shot("goats")
 panel.action.pressed.emit();assert(SaveData.repeat_contract165.active);assert(ProgressionEconomy165.target(SaveData.repeat_contract165)=="goat")
 for i in 5:assert(SaveData.record_goat104("qa-goat-%d"%i))
 panel.refresh();panel.action.pressed.emit();assert(SaveData.repeat_contract165.completed==2);assert(SaveData.equipment_points==1200)
 get_tree().root.size=Vector2i(960,540);await get_tree().process_frame;await shot("small")
 panel.closed.emit();await get_tree().process_frame;assert(world.player.is_physics_processing());print("CONTRACT167_QA_OK ",SaveData.equipment_points);world.queue_free();await get_tree().process_frame;get_tree().quit()
