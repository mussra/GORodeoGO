extends GutTest
var world:CountryPreview146
var previous:String
func before_each():
 previous=SaveData.save_path;SaveData.save_path="user://country146-test.dat";SaveData.world_seed=123;SaveData.world_generator_version=3;SaveData.country_ledger146={};SaveData.world_position=Vector2(999,470);SaveData._load_valid=true;SaveData.trial_session_active=false
func after_each():
 if is_instance_valid(world):world.free()
 SaveData._load_valid=true;SaveData.country_ledger146={};SaveData.save_path=previous;DirAccess.remove_absolute("user://country146-test.dat");await get_tree().process_frame
func walk(path:PackedVector2Array)->bool:
 for point in path:
  while world.player.position.distance_to(point)>.1:
   var motion:Vector2=(point-world.player.position).limit_length(12.)
   var hit:KinematicCollision2D=world.player.move_and_collide(motion)
   if hit!=null:return false
  world._process(0.)
 return true
func test_actual_player_can_walk_approach_both_banks_and_return_without_crossing_water():
 world=CountryPreview146.new();add_child(world);world.player.set_physics_process(false);await get_tree().physics_frame
 assert_true(walk(world.data.approach));assert_true(walk(world.data.upstream));assert_true(world.ledger.maps.water146.visited.has("source"))
 var reverse:PackedVector2Array=world.data.upstream.duplicate();reverse.reverse();assert_true(walk(reverse))
 reverse=world.data.approach.duplicate();reverse.reverse();assert_true(walk(reverse));assert_lt(world.player.position.distance_to(world.data.entry),1.)
func test_actual_river_collision_stops_a_direct_crossing():
 world=CountryPreview146.new();add_child(world);world.player.set_physics_process(false);await get_tree().physics_frame
 world.player.position=world.data.bank[2];var destination:Vector2=world.data.river[2]-Vector2(300,0)
 var hit:=world.player.move_and_collide(destination-world.player.position);assert_not_null(hit);assert_gt(world.player.position.distance_to(destination),100.)
func test_country_storage_reload_keeps_frontier_progress_and_position_separate():
 var origin:Vector2=SaveData.world_position;SaveData.world_discovered=["0,0","1,0"];SaveData.world_missions={"original":"done"};var horses:=SaveData.horse_collection.export_state()
 var state:=CountryLedger146.enter(CountryLedger146.fresh(123,3),origin,456);assert_true(SaveData.store_country_ledger146(state))
 SaveData.load_progress();assert_true(SaveData._load_valid);assert_eq(SaveData.country_ledger146,state);assert_eq(SaveData.world_position,origin);assert_eq(SaveData.world_discovered,["0,0","1,0"]);assert_eq(SaveData.world_missions,{"original":"done"});assert_eq(SaveData.horse_collection.export_state(),horses)
func test_failed_country_save_restores_memory_and_retains_disk_origin():
 var before:Dictionary=SaveData.country_ledger146.duplicate(true);var pos:Vector2=SaveData.world_position;assert_true(SaveData.save_progress())
 var state:=CountryLedger146.enter(CountryLedger146.fresh(123,3),pos,456);SaveData.save_path="user://missing146/countries.dat"
 assert_false(SaveData.store_country_ledger146(state));assert_push_error_count(1);assert_eq(SaveData.country_ledger146,before);assert_eq(SaveData.world_position,pos)
 SaveData.save_path="user://country146-test.dat";var disk:=ConfigFile.new();assert_eq(disk.load(SaveData.save_path),OK);assert_eq(disk.get_value("world","position"),pos);assert_eq(disk.get_value("world","countries146"),before)
func test_unknown_country_version_blocks_rewrite_of_original_save():
 assert_true(SaveData.save_progress());var config:=ConfigFile.new();assert_eq(config.load(SaveData.save_path),OK)
 config.set_value("world","countries146",{"version":99});assert_eq(config.save(SaveData.save_path),OK)
 var original:=FileAccess.get_file_as_bytes(SaveData.save_path);SaveData.load_progress();assert_false(SaveData._load_valid);assert_false(SaveData.save_progress());assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),original)
func test_frontier_preview_round_trip_keeps_world_and_disk_untouched():
 SaveData.world_position=WorldNominal98.home();SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_places144={};SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={}
 var frontier=load("res://src/Presentation/frontier_world.gd").new();add_child(frontier)
 while frontier._loading_world:await get_tree().process_frame
 frontier.set_process(false);frontier.player.set_physics_process(false);assert_true(SaveData.save_progress())
 var disk:=FileAccess.get_file_as_bytes(SaveData.save_path);var origin:Vector2=frontier.player.position;var seed_:int=SaveData.world_seed;var previous_camera=get_viewport().get_camera_2d()
 world=CountryPreview146.new();frontier._open_isolated_preview146(world);world.player.set_physics_process(false);await get_tree().process_frame
 assert_false(frontier.visible);assert_eq(frontier.process_mode,Node.PROCESS_MODE_DISABLED)
 world.player.position=world.data.sites.source;world._process(0.);world.return_requested.emit();await get_tree().process_frame
 assert_true(frontier.visible);assert_eq(frontier.player.position,origin);assert_eq(SaveData.world_position,origin);assert_eq(SaveData.world_seed,seed_);assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),disk);assert_eq(get_viewport().get_camera_2d(),previous_camera)
 frontier.free();await get_tree().process_frame
func test_legacy_save_without_countries_preserves_generator_and_coordinates():
 for gen in [1,2,3]:
  SaveData.country_ledger146={};SaveData.world_generator_version=gen;SaveData.world_position=Vector2(-12345,6789);assert_true(SaveData.save_progress())
  var config:=ConfigFile.new();assert_eq(config.load(SaveData.save_path),OK);config.erase_section_key("world","countries146");assert_eq(config.save(SaveData.save_path),OK)
  SaveData.load_progress();assert_true(SaveData._load_valid);assert_eq(SaveData.world_generator_version,gen);assert_eq(SaveData.world_position,Vector2(-12345,6789));assert_eq(SaveData.country_ledger146,{})
