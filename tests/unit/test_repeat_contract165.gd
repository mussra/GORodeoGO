extends GutTest
var sut:Node
func before_each():
 sut=load("res://src/Application/save_data.gd").new();sut.save_path="user://repeat165.dat";sut.horse_collection.seed_trial();sut.points_legacy_credit_applied=true
func after_each():
 sut.free();DirAccess.remove_absolute("user://repeat165.dat")
func test_contract_requires_new_captures_and_claim_can_repeat_after_reload():
 assert_true(sut.record_pig104("old"));assert_true(sut.accept_repeat_contract165());assert_eq(sut.repeat_contract165.events,[])
 assert_false(sut.record_pig104("old"));assert_true(sut.record_goat104("other"));assert_eq(sut.repeat_contract165.events,[])
 for i in 5:assert_true(sut.record_pig104("p%d"%i))
 assert_true(sut.repeat_contract165.ready);sut.load_progress();assert_true(sut.repeat_contract165.ready)
 var before:int=sut.equipment_points;assert_eq(sut.claim_repeat_contract165(),400);assert_eq(sut.equipment_points,before+400);assert_eq(sut.claim_repeat_contract165(),0)
 assert_true(sut.accept_repeat_contract165());assert_eq(ProgressionEconomy165.target(sut.repeat_contract165),"goat")
 for i in 5:assert_true(sut.record_goat104("g%d"%i))
 assert_eq(sut.claim_repeat_contract165(),400);assert_eq(sut.repeat_contract165.completed,2)
func test_capture_accept_and_claim_roll_back_points_ids_and_contract_when_save_fails():
 assert_true(sut.accept_repeat_contract165());var state:Dictionary=sut.repeat_contract165.duplicate(true);var points:int=sut.equipment_points
 sut._load_valid=false;assert_false(sut.record_pig104("failed"));assert_eq(sut.repeat_contract165,state);assert_eq(sut.world_pig_captures,[]);assert_eq(sut.equipment_points,points)
 assert_false(sut.record_goat104("failed"));assert_eq(sut.world_goat_captures,[]);assert_eq(sut.equipment_points,points)
 sut._load_valid=true
 for i in 5:sut.record_pig104("p%d"%i)
 state=sut.repeat_contract165.duplicate(true);points=sut.equipment_points;sut._load_valid=false
 assert_eq(sut.claim_repeat_contract165(),0);assert_eq(sut.repeat_contract165,state);assert_eq(sut.equipment_points,points)
 sut._load_valid=true;assert_eq(sut.claim_repeat_contract165(),400);state=sut.repeat_contract165.duplicate(true);sut._load_valid=false
 assert_false(sut.accept_repeat_contract165());assert_eq(sut.repeat_contract165,state)
func test_future_repeated_victories_are_capped_without_removing_existing_balance():
 sut.highest_level_completed=20;sut.equipment_points=80000
 assert_eq(sut.record_victory(20),400);assert_eq(sut.equipment_points,80400);assert_eq(sut.highest_level_completed,20)
 sut.highest_level_completed=19;assert_eq(sut.record_victory(20),8500);assert_eq(sut.equipment_points,88900)
func test_trials_cannot_claim_contract_points_or_persist_contract_changes():
 sut.trial_session_active=true
 assert_false(sut.accept_repeat_contract165());assert_eq(sut.claim_repeat_contract165(),0)
