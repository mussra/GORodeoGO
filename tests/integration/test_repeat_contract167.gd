extends GutTest
var world:Node2D
var previous:String
func before_each():
 previous=SaveData.save_path;SaveData.save_path="user://repeat167.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_position=WorldNominal98.home();SaveData.world_edits=[];SaveData.world_roaming139={};SaveData.country_ledger146={};SaveData.world_missions={};SaveData.world_quests={};SaveData.world_discovered=[];SaveData.world_places144={};SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_pig_captures=[];SaveData.world_goat_captures=[];SaveData.world_pigs_sold=0;SaveData.repeat_contract165=ProgressionEconomy165.new_contract();SaveData.equipment_points=0;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
func after_each():
 world.free();SaveData.save_path=previous;DirAccess.remove_absolute("user://repeat167.dat");await get_tree().process_frame
func test_farmer_entry_accept_claim_next_species_and_back_preserve_old_quests():
 NpcQuests.accept(SaveData.world_quests,"farmer_pigs")
 for i in 3:NpcQuests.record(SaveData.world_quests,"capture_animal","pig","old%d"%i)
 var old:=SaveData.world_quests.duplicate(true);var npc:Dictionary=NpcQuests.NPCS[0].duplicate(true);world.player.position=npc.position;world._open_npc(npc)
 assert_not_null(world._npc_dialog.get_node_or_null("RepeatContracts165"));world._npc_dialog.get_node("RepeatContracts165").pressed.emit();await get_tree().process_frame
 var panel:RepeatContractsPanel165=world._npc_dialog;assert_not_null(panel);assert_false(world.player.is_physics_processing());panel.action.pressed.emit();assert_true(SaveData.repeat_contract165.active);assert_true(panel.action.disabled);assert_true(SaveData.can_capture_animal165("pig"))
 for i in 5:assert_true(SaveData.record_pig104("pig%d"%i))
 panel.refresh();assert_false(panel.action.disabled);assert_eq(panel.action.text,"Cobrar 400 puntos");panel.action.pressed.emit();assert_eq(SaveData.equipment_points,600);assert_eq(SaveData.repeat_contract165.completed,1);assert_eq(SaveData.world_quests,old)
 panel.action.pressed.emit();assert_eq(ProgressionEconomy165.target(SaveData.repeat_contract165),"goat");assert_true(SaveData.can_capture_animal165("goat"));assert_true(SaveData.can_capture_animal165("pig"))
 for i in 5:assert_true(SaveData.record_goat104("goat%d"%i))
 panel.refresh();panel.action.pressed.emit();assert_eq(SaveData.equipment_points,1200);assert_eq(SaveData.repeat_contract165.completed,2)
 var event:=InputEventAction.new();event.action="ui_cancel";event.pressed=true;panel._unhandled_input(event);await get_tree().process_frame;assert_null(world._npc_dialog);assert_true(world.player.is_physics_processing())
func test_contract_state_is_visible_in_hud_and_no_legacy_reward_is_claimed():
 SaveData.world_pig_captures=["old"];assert_true(SaveData.accept_repeat_contract165());world._refresh_quest_hud();assert_true(world._quest_label.text.contains("0/5 cerdos"));assert_eq(SaveData.equipment_points,0)
 SaveData.load_progress();assert_eq(SaveData.repeat_contract165.events,[]);assert_true(SaveData.repeat_contract165.active)
func test_repeat_goat_contract_allows_real_lasso_and_capture_without_old_goat_quest():
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 assert_false(NpcQuests.can_capture(SaveData.world_quests,"goat"));SaveData.repeat_contract165=ProgressionEconomy165.new_contract(1);assert_true(SaveData.accept_repeat_contract165())
 var goat=world._prototype_goats.get_child(0);var id:String=goat.get_meta("capture_id112");world.player.position=goat.position-Vector2(160,0)
 world._on_lasso_prey_captured(goat);assert_eq(world._lasso_horse,goat);assert_true(goat.roped)
 goat.state.progress=1.;goat.state.tired=true;world._tick_goats(.01);await get_tree().process_frame
 assert_true(SaveData.world_goat_captures.has(id));assert_eq(SaveData.repeat_contract165.events,[id]);assert_eq(SaveData.equipment_points,40);assert_false(SaveData.world_quests.has("farmer_goats"))
