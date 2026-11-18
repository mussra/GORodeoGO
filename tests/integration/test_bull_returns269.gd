extends "res://tests/integration/test_mode_progress240.gd"
func test_returns_are_persisted_individually_and_replay_does_not_duplicate():
 assert_true(sut.record_bull_return269(2,0));assert_true(sut.record_bull_return269(2,1));assert_true(sut.record_bull_return269(2,0))
 assert_eq(sut.world_bull_returns269.size(),2)
 sut.load_progress();assert_eq(sut.world_bull_returns269.size(),2)
 assert_false(sut.record_bull_return269(2,2));assert_false(sut.record_bull_return269(0,0));assert_false(sut.record_bull_return269(41,0))
func test_trial_and_debug_never_add_animals():
 sut.trial_session_active=true;assert_false(sut.record_bull_return269(1,0));sut.trial_session_active=false
 sut.debug_mode=true;assert_false(sut.record_bull_return269(1,0));assert_eq(sut.world_bull_returns269.size(),0)
func test_failed_return_remains_pending_then_next_save_recovers_once():
 sut.save_path="user://missing269/fail.cfg";assert_false(sut.record_bull_return269(1,0));assert_push_error_count(1)
 assert_eq(sut.world_bull_returns269.size(),0);assert_eq(sut.pending_bull_returns269.size(),1)
 sut.save_path=PATH;assert_true(sut.save_progress());assert_eq(sut.world_bull_returns269.size(),1);assert_true(sut.pending_bull_returns269.is_empty())
 sut.load_progress();assert_eq(sut.world_bull_returns269.size(),1)
func test_corrupt_and_unknown_returns_are_ignored():
 assert_eq(sut.clean_bull_returns269({"1:0":true,"1:1":true,"-1:2":true,"1:00":true,"2:0":"yes"}),{"1:0":true})
func test_display_is_bounded_while_count_is_complete():
 var old:Dictionary=SaveData.world_bull_returns269.duplicate(true)
 for i in 10:SaveData.world_bull_returns269["x%d"%i]=true
 var holder:=Node2D.new();add_child(holder);var pen:=FarmerCorral269.new();holder.add_child(pen)
 assert_eq(pen.actors.size(),6);assert_true(pen.label.text.contains(str(SaveData.world_bull_returns269.size())));holder.free();SaveData.world_bull_returns269=old
func test_real_rodeo_return_hook_populates_frontier_ledger():
 var snapshot:Dictionary={}
 for property in SaveData.get_script().get_script_property_list():
  var value:Variant=SaveData.get(property.name);snapshot[property.name]=value.duplicate(true) if value is Dictionary or value is Array else value
 SaveData.save_path="user://hook269.cfg";SaveData._load_valid=true;SaveData.debug_mode=false;SaveData.trial_session_active=false;SaveData.rodeo_intro240=true;SaveData.dual_lasso_intro_shown=true;SaveData.world_bull_returns269={};SaveData.horse_collection.seed_trial();GameState.selected_level=1
 var scene:Node=load("res://src/Presentation/level_0.tscn").instantiate();add_child(scene)
 scene._win_requires_all_bulls=false;scene._on_bull_returned(scene._active_bulls[0])
 assert_true(SaveData.world_bull_returns269.has("1:0"));assert_eq(scene._bulls_returned,1)
 scene.free();DirAccess.remove_absolute(SaveData.save_path)
 for key in snapshot:SaveData.set(key,snapshot[key])
