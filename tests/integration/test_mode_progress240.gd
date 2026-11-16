extends GutTest
var sut:Node
const PATH:String="user://progress240-test.cfg"
func before_each()->void:
 sut=load("res://src/Application/save_data.gd").new();sut.save_path=PATH;sut.horse_collection.seed_trial()
func after_each()->void:
 sut.free()
 if FileAccess.file_exists(PATH):DirAccess.remove_absolute(PATH)
func test_win_atomic_roundtrip_duplicate_and_course_facts()->void:
 var ticket:Dictionary=sut.victory_ticket240("race")
 assert_true(sut.record_mode_victory240(ticket,2))
 assert_false(sut.record_mode_victory240(ticket,2))
 var cfg:=ConfigFile.new();assert_eq(cfg.load(PATH),OK)
 assert_eq(cfg.get_value("progress","victories240").wins,{"race":1})
 assert_eq(cfg.get_value("progress","victories240").courses,{"2":1})
 assert_false(cfg.get_value("progress","rodeo_intro240"))
func test_failed_save_is_recoverable_once_and_blocks_new_run()->void:
 var ticket:Dictionary=sut.victory_ticket240("duel")
 sut.save_path="user://nonexistent240/fail.cfg"
 assert_false(sut.record_mode_victory240(ticket));assert_push_error_count(1)
 assert_eq(sut.victories240.wins,{})
 assert_false(sut.pending_victory240.is_empty())
 assert_false(sut.mode_open240("duel"))
 assert_false(sut.record_mode_victory240(sut.victory_ticket240("joust")))
 sut.save_path=PATH
 assert_true(sut.retry_victory240())
 assert_true(sut.retry_victory240())
 assert_eq(sut.victories240.wins,{"duel":1})
func test_trial_and_debug_switch_cannot_write_results()->void:
 var ticket:Dictionary=sut.victory_ticket240("joust")
 sut.debug_mode=true;assert_false(sut.record_mode_victory240(ticket))
 sut.debug_mode=false;sut.trial_session_active=true;assert_false(sut.record_mode_victory240(ticket))
 sut.trial_session_active=false
 assert_eq(sut.victories240.wins,{})
func test_first_mission_requires_quest_and_atomic_acceptance()->void:
 assert_false(sut.accept_rodeo240())
 sut.world_quests={"farmer_pigs":{"status":"done"}}
 assert_true(sut.accept_rodeo240())
 assert_true(sut.mode_open240("bulls"))
 assert_false(sut.world_missions.has("rodeo_intro240"),"No generic herd mission pollution")
 var cfg:=ConfigFile.new();assert_eq(cfg.load(PATH),OK);assert_true(cfg.get_value("progress","rodeo_intro240"))
func test_justa_is_not_also_a_duel()->void:
 assert_true(sut.record_mode_victory240(sut.victory_ticket240("joust")))
 assert_eq(sut.victories240.wins,{"joust":1})
