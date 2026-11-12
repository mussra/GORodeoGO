extends GutTest
var session:CountrySession152
var transition:CountryTransition152
var previous:String
var restored:int=0
func before_each():
 previous=SaveData.save_path;SaveData.save_path="user://session152.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=123;SaveData.world_generator_version=3;SaveData.world_position=Vector2(999,470);SaveData.country_ledger146={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_discovered=["0,0"];SaveData.world_missions={"original":"done"};SaveData.world_roaming139={};assert_true(SaveData.save_progress());session=CountrySession152.new();transition=CountryTransition152.new();restored=0
func after_each():
 if is_instance_valid(session):session.free()
 SaveData._load_valid=true;SaveData.country_ledger146={};SaveData.save_path=previous;DirAccess.remove_absolute("user://session152.dat");await get_tree().process_frame
func load_session()->bool:
 add_child(session);await get_tree().physics_frame;return true
func validate()->Vector2:return TravelLanding148.find(session.player,session.ledger.maps.water146.position,func(pos):return CountryRoute146.blocked(session.data,pos))
func restore()->bool:restored+=1;return true
func enter()->Dictionary:return await transition.enter152(session,SaveData.world_position,load_session,validate,restore)
func test_entry_save_walk_reload_and_local_siesta_never_modify_original_world():
 var result:=await enter();assert_true(result.ok);assert_true(session.activated);session.player.set_physics_process(false)
 var data:=session.data;session.player.position=data.sites.source;session._process(0.);assert_true(session.save_now152());var saved:=SaveData.country_ledger146.duplicate(true);assert_eq(SaveData.world_position,Vector2(999,470));assert_eq(SaveData.world_discovered,["0,0"]);assert_eq(SaveData.world_missions,{"original":"done"})
 SaveData.load_progress();assert_eq(SaveData.country_ledger146,saved);assert_true(await session.start_siesta("entry"));assert_eq(SaveData.country_ledger146.maps.water146.position,data.entry);SaveData.load_progress();assert_eq(SaveData.country_ledger146.maps.water146.position,data.entry)
func test_new_entry_load_and_save_failure_leave_disk_on_original_country():
 var before:=FileAccess.get_file_as_bytes(SaveData.save_path)
 var result:=await transition.enter152(session,SaveData.world_position,func():return false,func():return Vector2.ZERO,restore)
 assert_false(result.ok);assert_eq(restored,1);assert_eq(SaveData.country_ledger146,{});assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),before)
 result=await transition.enter152(session,SaveData.world_position,load_session,func():SaveData._load_valid=false;return validate(),restore)
 assert_false(result.ok);assert_eq(result.reason,"save");assert_false(session.activated);assert_eq(restored,2);assert_eq(SaveData.country_ledger146,{});assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),before)
func test_blocked_initial_landing_does_not_commit_or_activate():
 var result:=await transition.enter152(session,SaveData.world_position,load_session,func():return Vector2(INF,INF),restore)
 assert_false(result.ok);assert_false(session.activated);assert_eq(SaveData.country_ledger146,{});assert_eq(restored,1)
func test_failed_siesta_destination_save_restores_origin_both_in_memory_and_disk():
 assert_true((await enter()).ok);session.player.set_physics_process(false);session.player.position=session.data.sites.source;session._process(0.);assert_true(session.save_now152());assert_true(await session.start_siesta("entry"));var origin:Vector2=session.player.position
 var fail:=get_tree().create_timer(.25,true);fail.timeout.connect(func():SaveData._load_valid=false)
 assert_false(await session.start_siesta("source"));assert_eq(session.player.position,origin);assert_eq(SaveData.country_ledger146.maps.water146.position,origin);var config:=ConfigFile.new();assert_eq(config.load(SaveData.save_path),OK);assert_eq(config.get_value("world","countries146").maps.water146.position,origin)
func test_exit_validates_original_arrival_then_atomically_changes_active_map_and_position():
 assert_true((await enter()).ok);session.player.set_physics_process(false);session.player.position=session.data.sites.source;session._process(0.)
 var result:=await transition.exit152(session,func():return Vector2(1000,470),restore);assert_true(result.ok);assert_eq(SaveData.country_ledger146.active,"frontier");assert_eq(SaveData.world_position,Vector2(1000,470));assert_true(SaveData.country_ledger146.maps.water146.visited.source);SaveData.load_progress();assert_eq(SaveData.world_position,Vector2(1000,470));assert_eq(SaveData.country_ledger146.active,"frontier")
func test_exit_save_or_source_collision_failure_stays_in_country_without_changing_disk():
 assert_true((await enter()).ok);session.player.set_physics_process(false);var state:=SaveData.country_ledger146.duplicate(true);var disk:=FileAccess.get_file_as_bytes(SaveData.save_path)
 var result:=await transition.exit152(session,func():return Vector2(INF,INF),restore);assert_false(result.ok);assert_eq(restored,1);assert_eq(SaveData.country_ledger146,state);assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),disk)
 SaveData._load_valid=false;result=await transition.exit152(session,func():return Vector2(1000,470),restore);assert_false(result.ok);assert_eq(SaveData.world_position,Vector2(999,470));assert_eq(SaveData.country_ledger146,state);assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),disk)
func test_resume_restores_saved_country_position_exploration_visits_and_seed():
 assert_true((await enter()).ok);session.player.set_physics_process(false);session.player.position=session.data.sites.source;session._process(0.);assert_true(session.save_now152());var state:=SaveData.country_ledger146.duplicate(true);session.free();await get_tree().process_frame
 SaveData.load_progress();session=CountrySession152.new();session.seed=999999;transition=CountryTransition152.new();assert_true((await enter()).ok);session.player.set_physics_process(false);assert_eq(session.player.position,state.maps.water146.position);assert_eq(session.seed,state.maps.water146.seed);assert_eq(session.visited_cells,state.maps.water146.explored);assert_true(session.ledger.maps.water146.visited.source)
func test_autosave_and_failed_menu_save_preserve_last_successful_checkpoint():
 assert_true((await enter()).ok);session.player.set_physics_process(false);session.player.position=session.data.sites.source;session._process(5.1);var state:=SaveData.country_ledger146.duplicate(true);assert_eq(state.maps.water146.position,session.data.sites.source)
 SaveData._load_valid=false;session.player.position=session.data.entry;session._process(5.1);assert_eq(SaveData.country_ledger146,state);assert_false(session.save_error.is_empty());var current=get_tree().current_scene;session.suspend_to_menu152();assert_eq(get_tree().current_scene,current);assert_false(session.is_queued_for_deletion())
func test_trial_invalid_origin_and_busy_transition_do_not_load_or_write():
 var before:=FileAccess.get_file_as_bytes(SaveData.save_path);var result:Dictionary
 SaveData.trial_session_active=true;result=await enter();assert_false(result.ok);assert_false(session.is_inside_tree());SaveData.trial_session_active=false
 result=await transition.enter152(session,Vector2(INF,0),load_session,validate,restore);assert_false(result.ok);assert_false(session.is_inside_tree());transition.busy=true;result=await enter();assert_eq(result.reason,"busy");assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),before)
