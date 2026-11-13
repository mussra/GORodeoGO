extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(id:String):
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/details179-"+id+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1600,720)
 SaveData.save_path="user://qa179.dat";SaveData.trial_session_active=false;SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.country_ledger146={};SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_places144={};SaveData.world_position=WorldNominal98.home();SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.repeat_contract165=ProgressionEconomy165.new_contract();SaveData.save_progress()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false);world.set_process(false);await get_tree().create_timer(.5).timeout;world._toasts.clear();await shot("inicio")
 for id in ["east_flower","farmer_pigs","florist_blue105"]:NpcQuests.accept(SaveData.world_quests,id)
 world._refresh_quest_hud();world._quest_toggle.pressed.emit();await shot("encargos-1600")
 get_tree().root.size=Vector2i(960,540);await shot("encargos-960")
 var scroller:QuestDetails179=world._quest_details179
 var origin:Vector2=scroller.get_global_rect().get_center();var touch:=InputEventScreenTouch.new();touch.index=0;touch.pressed=true;touch.position=get_viewport().get_screen_transform()*origin;Input.parse_input_event(touch);await get_tree().process_frame
 for i in 8:
  var drag:=InputEventScreenDrag.new();drag.index=0;drag.position=get_viewport().get_screen_transform()*(origin-Vector2(0,20*(i+1)));drag.relative=Vector2(0,-20);Input.parse_input_event(drag);await get_tree().process_frame
 touch.pressed=false;touch.position=get_viewport().get_screen_transform()*(origin-Vector2(0,160));Input.parse_input_event(touch);await get_tree().process_frame
 assert(scroller.scroll_vertical>0);await shot("encargos-scroll-960")
 world._quest_toggle.pressed.emit();await shot("minimapa-960")
 world._open_navigation();assert(not world._navigation.entries.any(func(e):return e.id=="map"));var menu179:NavigationSheet=world._navigation;world._close_navigation();menu179.queue_free();await get_tree().process_frame;assert(world._map_overlay.visible);world._toggle_map();world._toggle_map();assert(world._map_overlay.visible and not world._map_overlay.expanded)
 world._open_npc(world._npcs98()[0]);await shot("granjero-960")
 if is_instance_valid(world._npc_dialog):world._close_npc()
 var p:=RepeatContractsPanel165.new();world._hud.add_child(p);await shot("contrato-960");p.free()
 SaveData.world_cousins140.known={"north":true}
 # Journal IDs come from the real definitions, not a hand-authored list.
 SaveData.world_cousins140.known={}
 for id in VillageCousins140.IDS:SaveData.world_cousins140.known[id]=true
 world._show_journal140();await shot("diario-960")
 world._journal140.queue_free();world._journal140=null;await get_tree().process_frame
 world._open_board();await shot("tablon-960");world._board_panel.queue_free();await get_tree().process_frame
 SaveData.ensure_flora138()
 var florist:=FloristDialog138.new();florist.setup_journey(false);world._hud.add_child(florist);await shot("florista-960");florist.queue_free();await get_tree().process_frame
 var cousin:=CousinDialog140.new();cousin.setup(VillageCousins140.IDS[0],SaveData.world_cousins140,false);world._hud.add_child(cousin);await shot("primo-960");cousin.queue_free();await get_tree().process_frame
 world._toast("Nota guardada · mantén pulsado sobre ella para editar o eliminar");await shot("aviso-960")
 print("DETAIL179_VISUAL_AND_MINIMAP_CHECK_OK")
 get_tree().quit()
