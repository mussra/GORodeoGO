extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(id:String):
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/buttons180-"+id+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1600,720)
 SaveData.save_path="user://qa180.dat";SaveData.trial_session_active=false;SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.country_ledger146={};SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_places144={};SaveData.world_position=WorldNominal98.home();SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.repeat_contract165=ProgressionEconomy165.new_contract();SaveData.save_progress()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false);world.set_process(false);await get_tree().create_timer(.5).timeout;world._toasts.clear();await shot("inicio")
 world.player.position=world._npcs98()[0].position+Vector2(0,50);world._tick_npcs();world._board_button.visible=true
 await shot("contextuales-1600");get_tree().root.size=Vector2i(960,540);await shot("contextuales-960")
 assert(world._npc_button.visible and world._board_button.visible)
 assert(not world._npc_button.get_rect().intersects(world._board_button.get_rect()))
 await tap(world._npc_button);assert(is_instance_valid(world._npc_dialog));await shot("granjero-960");world._close_npc();await get_tree().process_frame;world.player.set_physics_process(false)
 await tap(world._board_button);assert(is_instance_valid(world._board_panel));await shot("tablon-960");world._board_panel.queue_free();await get_tree().process_frame
 var journal:Button=world._hud.get_node("CousinJournal180");await tap(journal);assert(is_instance_valid(world._journal140));await shot("primos-960");world._journal140.queue_free();world._journal140=null;await get_tree().process_frame
 world._flower_button.visible=true;await shot("flor-960")
 world._flower_button.visible=false;world._toggle_edit();await shot("herramientas-960")
 print("BUTTON180_TOUCH_AND_LAYOUT_OK");get_tree().quit()
func tap(button:Button):
 var event:=InputEventScreenTouch.new();event.index=0;event.position=get_viewport().get_screen_transform()*button.get_global_rect().get_center();event.pressed=true;Input.parse_input_event(event);await get_tree().process_frame;event.pressed=false;Input.parse_input_event(event);await get_tree().process_frame
