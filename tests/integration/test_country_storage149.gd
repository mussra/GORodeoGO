extends GutTest
var previous:String
func before_each():
 previous=SaveData.save_path;SaveData.save_path="user://storage149.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=123;SaveData.world_generator_version=3;SaveData.world_position=Vector2(999,470);SaveData.country_ledger146={}
func after_each():
 SaveData._load_valid=true;SaveData.country_ledger146={};SaveData.save_path=previous;DirAccess.remove_absolute("user://storage149.dat");await get_tree().process_frame
func test_legacy_v1_migrates_in_memory_but_does_not_rewrite_on_read():
 var legacy:=CountryLedger146.enter(CountryLedger146.fresh(123,3),SaveData.world_position,456);legacy.version=1;legacy.maps.water146.erase("explored");legacy.maps.water146.notes={"a":"pista"}
 SaveData.country_ledger146=legacy.duplicate(true);assert_true(SaveData.save_progress());var before:=FileAccess.get_file_as_bytes(SaveData.save_path);SaveData.load_progress()
 assert_true(SaveData._load_valid);assert_eq(SaveData.country_ledger146.version,2);assert_eq(SaveData.country_ledger146.maps.water146.notes,legacy.maps.water146.notes);assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),before);assert_eq(SaveData.world_position,Vector2(999,470));assert_true(SaveData.save_progress());var config:=ConfigFile.new();assert_eq(config.load(SaveData.save_path),OK);assert_eq(config.get_value("world","countries146").version,2)
func test_exploration_reload_and_failed_save_keep_original_world_and_progress():
 var state:=CountryLedger146.enter(CountryLedger146.fresh(123,3),SaveData.world_position,456);var data:=CountryRoute146.plan(456);var cells:Dictionary={};CountryExploration148.reveal(cells,data.sites.source);state=CountryLedger146.record_exploration(state,data.sites.source,cells)
 assert_true(SaveData.store_country_ledger146(state));SaveData.load_progress();assert_eq(SaveData.country_ledger146,state);assert_eq(SaveData.world_position,Vector2(999,470));var before:=FileAccess.get_file_as_bytes(SaveData.save_path)
 var next:=CountryLedger146.record_position(state,data.entry);SaveData.save_path="user://missing149/storage.dat";assert_false(SaveData.store_country_ledger146(next));assert_push_error_count(1);assert_eq(SaveData.country_ledger146,state);assert_eq(FileAccess.get_file_as_bytes("user://storage149.dat"),before)
func test_malformed_exploration_blocks_rewrite_of_source():
 assert_true(SaveData.save_progress());var config:=ConfigFile.new();assert_eq(config.load(SaveData.save_path),OK);var state:=CountryLedger146.enter(CountryLedger146.fresh(123,3),SaveData.world_position,456);state.maps.water146.explored={Vector2i(-1,0):true};config.set_value("world","countries146",state);assert_eq(config.save(SaveData.save_path),OK)
 var before:=FileAccess.get_file_as_bytes(SaveData.save_path);SaveData.load_progress();assert_false(SaveData._load_valid);assert_false(SaveData.save_progress());assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),before)
