extends "res://tests/integration/test_breeding_world256.gd"
func done_pigs268():
 SaveData.world_quests={"farmer_pigs":{"status":"done","count":3,"events":["a","b","c"]}};SaveData.rodeo_intro240=false
func test_completed_existing_save_is_open_without_acceptance_and_shows_notice():
 done_pigs268();assert_true(SaveData.mode_open240("bulls"));await launch();world._maybe_offer_rodeo268()
 assert_true(world._npc_dialog is RodeoOffer268)
 world._npc_dialog.closed.emit();assert_null(world._npc_dialog);assert_true(SaveData.mode_open240("bulls"))
 SaveData.load_progress();assert_true(SaveData.rodeo_intro240)
func test_notice_is_not_repeated_each_frame_and_does_not_hide_access():
 done_pigs268();await launch();world._maybe_offer_rodeo268()
 assert_true(world._npc_dialog is RodeoOffer268);world._npc_dialog.closed.emit()
 world._maybe_offer_rodeo268();assert_null(world._npc_dialog);assert_true(SaveData.mode_open240("bulls"))
func test_third_pig_automatically_opens_rodeo_and_queues_notice():
 SaveData.world_quests={"farmer_pigs":{"status":"active","count":2,"events":["a","b"]}};SaveData.rodeo_intro240=false
 await launch();world._maybe_offer_rodeo268();assert_null(world._npc_dialog);assert_false(SaveData.mode_open240("bulls"))
 assert_true(SaveData.record_pig104("third268"));assert_true(SaveData.mode_open240("bulls"));world._maybe_offer_rodeo268();assert_true(world._npc_dialog is RodeoOffer268)
func test_incomplete_quest_keeps_gate_and_next_chain_no_longer_needs_acceptance():
 SaveData.world_quests={};SaveData.rodeo_intro240=false;assert_false(SaveData.accept_rodeo240());assert_false(SaveData.mode_open240("bulls"))
 done_pigs268();SaveData.highest_level_completed=1;SaveData.world_places144={"visited":{"home":true,"a":true,"b":true}}
 assert_true(SaveData.mode_open240("race"));assert_false(SaveData.mode_open240("duel"))
func test_failed_notice_save_does_not_close_rodeo():
 done_pigs268();await launch();world._maybe_offer_rodeo268()
 var path:String=SaveData.save_path;SaveData.save_path="user://missing268/fail.cfg"
 world._npc_dialog.closed.emit();assert_push_error_count(1)
 assert_true(SaveData.mode_open240("bulls"));assert_null(world._npc_dialog);SaveData.save_path=path
