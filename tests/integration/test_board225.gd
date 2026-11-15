extends GutTest
var world:Node2D
func before_each():
 SaveData.save_path="user://board225-isolated.cfg";SaveData.world_seed=7781;SaveData.world_generator_version=3;SaveData.world_position=Vector2(310,190);SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_quests={};SaveData.world_missions={};SaveData.world_pigs.clear();SaveData.repeat_contract165=ProgressionEconomy165.new_contract()
 world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 while world._loading_world:await wait_process_frames(1)
 await wait_seconds(.5);world.set_process(false);world.set_physics_process(false)
func after_each():
 world.free();get_tree().paused=false;await wait_process_frames(2)
func text(n:Node)->String:
 var out:String=n.text+"\n" if n is Label else ""
 for c in n.get_children():out+=text(c)
 return out
func test_accept_from_farmer_visible_in_board_and_capture_enabled():
 var farmer:Dictionary=world._npcs98().filter(func(n):return n.id=="farmer")[0];world.player.position=farmer.position
 world._open_npc(farmer);assert_not_null(world._npc_dialog)
 world._npc_dialog.accepted.emit("farmer_pigs");await wait_process_frames(2)
 assert_eq(NpcQuests.state(SaveData.world_quests,"farmer_pigs").status,"active");assert_true(SaveData.can_capture_animal165("pig"))
 world._open_board();await wait_process_frames(3)
 assert_true(text(world._board_panel).contains("cerdos"),"Accepted pig objective must be visible on the board, not only a herd")
 assert_true(text(world._board_panel).contains("0 / 3"));assert_true(text(world._board_panel).contains("m"),"Known nearest objective has direction and distance")
 assert_not_null(world._missions_label);assert_true(text(world._quest_panel).contains("cerdos"))
func test_board_keeps_existing_herd_and_shows_new_farmer_objective():
 SaveData.world_missions["herd_1,0"]="encargo";NpcQuests.accept(SaveData.world_quests,"farmer_pigs");world._open_board();await wait_process_frames(3)
 var body:String=text(world._board_panel);assert_true(body.contains("cerdos"));assert_true(body.contains("manada"));assert_eq(WorldMissions.current_encargo(),"herd_1,0")
func test_repeat_contract_refreshes_counter_and_board():
 var before:String=world._missions_label.text;assert_true(SaveData.accept_repeat_contract165());world._refresh_missions();world._refresh_quest_hud();world._open_board();await wait_process_frames(3)
 assert_true(text(world._board_panel).contains("0 / 5"));assert_ne(world._missions_label.text,before)
func test_repeat_accept_via_farmer_panel_updates_on_return_and_capture_progress():
 var farmer:Dictionary=world._npcs98().filter(func(n):return n.id=="farmer")[0];world.player.position=farmer.position
 world._open_npc(farmer);world._npc_dialog.contracts_requested165.emit();await wait_process_frames(2)
 var panel:RepeatContractsPanel165=world._npc_dialog;assert_not_null(panel);panel.action.pressed.emit();assert_true(SaveData.repeat_contract165.active)
 panel.closed.emit();await wait_process_frames(2);world._open_board();await wait_process_frames(2);assert_true(text(world._board_panel).contains("0 / 5"))
 assert_true(SaveData.record_pig104("board225-capture"));world._refresh_quest_hud();world._refresh_missions();world._open_board();await wait_process_frames(3)
 assert_true(text(world._board_panel).contains("1 / 5"));assert_eq(SaveData.repeat_contract165.events.size(),1)
func test_unknown_animals_do_not_get_an_invented_direction():
 for pig in world._lasso_pigs():pig.queue_free()
 await wait_process_frames(2);assert_eq(world._board_route225("pig"),"Busca en la zona explorada")

func test_finished_farmer_objective_waits_for_thanks_without_adding_a_herd():
 NpcQuests.accept(SaveData.world_quests,"farmer_pigs")
 for n in 3:NpcQuests.record(SaveData.world_quests,"capture_animal","pig","pig-done-"+str(n))
 world._open_board();await wait_process_frames(3)
 assert_true(text(world._board_panel).contains("3 / 3"));assert_true(text(world._board_panel).contains("Habla con el granjero"));assert_eq(WorldMissions.current_encargo(),"")
 assert_gt(world._board_panel.z_index,100,"Board must not sit below the capture toast")
func test_saved_accept_and_progress_reopen_on_board_after_reload():
 NpcQuests.accept(SaveData.world_quests,"farmer_pigs");assert_true(SaveData.record_pig104("board225-reload"));assert_true(SaveData.save_progress())
 SaveData.world_quests={};SaveData.load_progress();world._open_board();await wait_process_frames(3)
 assert_true(text(world._board_panel).contains("1 / 3"));assert_true(SaveData.can_capture_animal165("pig"))
func test_flower_route_and_finished_story_do_not_send_to_the_wrong_npc():
 NpcQuests.accept(SaveData.world_quests,"florist_blue105");NpcQuests.accept(SaveData.world_quests,"east_flower");NpcQuests.record(SaveData.world_quests,"find_object","east_flower","east225")
 world._open_board();await wait_process_frames(3)
 var body:String=text(world._board_panel);assert_true(body.contains("aura de la flor en el mapa"));assert_false(body.contains("Habla con la florista"))
