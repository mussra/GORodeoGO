extends GutTest
const PATH="user://pending195-only.cfg"
func after_each():
 RaceCupSession194.path_override="";RaceCupSession194.active=false;RaceCupSession194.pending_result.clear();RaceCupSession194.pending_path=""
 if FileAccess.file_exists(PATH):DirAccess.remove_absolute(PATH)
func test_pending_retry_is_mode_bound_and_recorded_once():
 RaceCupSession194.path_override=PATH
 RaceCupSession194.pending_path=PATH
 RaceCupSession194.pending_result={"sequence":1,"mode":"race","finished":true,"course":0,"rank":1,"gates":16,"landed":0,"dodges":0,"hits":0}
 assert_false(RaceCupSession194.begin().ok)
 RaceCupSession194.path_override=PATH+"other";assert_false(RaceCupSession194.retry_pending().ok)
 RaceCupSession194.path_override=PATH;assert_true(RaceCupSession194.retry_pending().ok)
 assert_true(RaceCupSession194.pending_result.is_empty());assert_false(RaceCupSession194.retry_pending().ok)
 assert_eq(RaceCupStore194.read_state(PATH).state.completed,["learn_oval"])
