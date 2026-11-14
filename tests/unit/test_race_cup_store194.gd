extends GutTest
const PATH="user://cup194-isolated-test.cfg"
func before_each():
 for path in [PATH,PATH+".tmp"]:
  if FileAccess.file_exists(path):DirAccess.remove_absolute(path)
func after_each():before_each()
func result(sequence:int,course:int=0)->Dictionary:
 return {"sequence":sequence,"mode":"race","finished":true,"course":course,"rank":1,"gates":16,"landed":1,"dodges":1,"hits":0}
func test_missing_file_is_not_created_by_read_and_atomic_round_trip_is_valid():
 assert_true(RaceCupStore194.read_state(PATH).new)
 assert_false(FileAccess.file_exists(PATH))
 assert_true(RaceCupStore194.record_result(PATH,result(1)).ok)
 assert_eq(RaceCupStore194.read_state(PATH).state.completed,["learn_oval"])
 assert_false(FileAccess.file_exists(PATH+".tmp"))
func test_repeat_result_never_counts_twice_or_rewrites_file():
 RaceCupStore194.record_result(PATH,result(1));var bytes:PackedByteArray=FileAccess.get_file_as_bytes(PATH)
 assert_false(RaceCupStore194.record_result(PATH,result(1,1)).ok)
 assert_eq(FileAccess.get_file_as_bytes(PATH),bytes)
func test_corrupt_and_unknown_versions_are_preserved_byte_for_byte():
 var file:=FileAccess.open(PATH,FileAccess.WRITE);file.store_string("not a config file");file.close()
 var bytes:PackedByteArray=FileAccess.get_file_as_bytes(PATH)
 assert_false(RaceCupStore194.read_state(PATH).ok)
 assert_false(RaceCupStore194.record_result(PATH,result(1)).ok)
 assert_eq(FileAccess.get_file_as_bytes(PATH),bytes)
 var config:=ConfigFile.new();config.set_value("cup","state",{"rule":99,"completed":[],"last_sequence":0});config.save(PATH)
 bytes=FileAccess.get_file_as_bytes(PATH)
 assert_false(RaceCupStore194.write_state(PATH,RaceCup194.fresh()).ok)
 assert_eq(FileAccess.get_file_as_bytes(PATH),bytes)
func test_stale_or_conflicting_writes_cannot_remove_progress():
 RaceCupStore194.record_result(PATH,result(1))
 assert_false(RaceCupStore194.write_state(PATH,RaceCup194.fresh()).ok)
 var conflicting:=RaceCup194.fresh();conflicting.last_sequence=1
 assert_false(RaceCupStore194.write_state(PATH,conflicting).ok)
 assert_eq(RaceCupStore194.read_state(PATH).state.completed,["learn_oval"])
func test_write_failure_returns_failure_without_advancing_live_state():
 var state:=RaceCup194.fresh();var before:String=var_to_str(state)
 assert_false(RaceCupStore194.write_state("user://missing194/child.cfg",state).ok)
 assert_eq(var_to_str(state),before)
func test_existing_main_progress_is_not_a_dependency():
 var highest:int=SaveData.highest_level_completed;var selected:String=SaveData.horse_collection.selected
 assert_true(RaceCupStore194.record_result(PATH,result(1)).ok)
 assert_eq(SaveData.highest_level_completed,highest);assert_eq(SaveData.horse_collection.selected,selected)
