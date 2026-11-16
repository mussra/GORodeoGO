extends GutTest
var old_path:String
var old_debug:bool
var old_horses:Dictionary
var old_wins:Dictionary
var old_level:int
var old_points:int
var scene:Node
func before_each()->void:
 old_path=SaveData.save_path;old_debug=SaveData.debug_mode;old_horses=SaveData.horse_collection.export_state();old_wins=SaveData.victories240.duplicate(true);old_level=SaveData.highest_level_completed;old_points=SaveData.equipment_points
 SaveData.debug_mode=true;SaveData.save_path="user://rodeo241-good.cfg";SaveData.points_legacy_credit_applied=true;SaveData.victories240=ModeVictories240.fresh();SaveData.highest_level_completed=0;SaveData.equipment_points=0
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 SaveData.dual_lasso_intro_shown=true
 GameState.selected_level=1
 scene=load("res://src/Presentation/level_0.tscn").instantiate();add_child(scene)
func after_each()->void:
 if is_instance_valid(scene):scene.free()
 SaveData.save_path=old_path;SaveData.debug_mode=old_debug;SaveData.horse_collection.restore(old_horses);SaveData.victories240=old_wins;SaveData.highest_level_completed=old_level;SaveData.equipment_points=old_points
 if FileAccess.file_exists("user://rodeo241-good.cfg"):DirAccess.remove_absolute("user://rodeo241-good.cfg")
func test_failed_win_retries_without_duplicate_points_horses_or_victories()->void:
 var before:Dictionary=SaveData.horse_collection.export_state()
 SaveData.save_path="user://missing-rodeo241/fail.cfg"
 scene._trigger_win();assert_push_error_count(1)
 assert_true(scene._rodeo_unsaved241);assert_false(SaveData.rodeo_saved241)
 assert_eq(SaveData.horse_collection.export_state(),before);assert_eq(SaveData.victories240.wins,{});assert_eq(SaveData.highest_level_completed,0);assert_eq(SaveData.equipment_points,0)
 assert_true(scene.hud.restart_button.visible);assert_false(scene.hud._next_button.visible);assert_false(scene.hud.quit_button.visible)
 assert_string_contains(scene.hud.end_label.text,"No se ha guardado")
 assert_true(scene.hud.restart_button.size.x>=300);assert_true(scene.hud.restart_button.size.y>=60)
 scene._on_next_requested();scene._on_quit_requested();assert_true(is_instance_valid(scene))
 scene._on_restart_requested();assert_push_error_count(2)
 assert_eq(SaveData.victories240.wins,{});assert_eq(SaveData.horse_collection.export_state(),before)
 SaveData.save_path="user://rodeo241-good.cfg"
 scene._on_restart_requested()
 assert_false(scene._rodeo_unsaved241);assert_true(SaveData.rodeo_saved241);assert_eq(SaveData.highest_level_completed,1);assert_eq(SaveData.victories240.wins,{"bulls":1})
 var points:int=SaveData.equipment_points;var horses:Dictionary=SaveData.horse_collection.export_state()
 scene._trigger_win();assert_eq(SaveData.equipment_points,points);assert_eq(SaveData.horse_collection.export_state(),horses);assert_eq(SaveData.victories240.wins,{"bulls":1})
 var cfg:=ConfigFile.new();assert_eq(cfg.load(SaveData.save_path),OK);assert_eq(cfg.get_value("progress","highest_level_completed"),1)
 assert_eq(cfg.get_value("progress","victories240").wins,{"bulls":1})
func test_successful_save_shows_confirmation()->void:
 scene._trigger_win();assert_true(SaveData.rodeo_saved241);assert_false(scene._rodeo_unsaved241)
 assert_string_contains(scene.hud.end_label.text,"Victoria guardada")
func test_touch_retry_button_recovers_the_same_victory()->void:
 SaveData.save_path="user://missing-rodeo241/fail.cfg"
 scene._trigger_win();assert_push_error_count(1)
 SaveData.save_path="user://rodeo241-good.cfg"
 await wait_process_frames(2)
 var at:Vector2=scene.hud.restart_button.get_global_rect().get_center()
 var press:=InputEventScreenTouch.new();press.index=0;press.position=at;press.pressed=true;Input.parse_input_event(press)
 await wait_process_frames(2)
 var release:=InputEventScreenTouch.new();release.index=0;release.position=at;release.pressed=false;Input.parse_input_event(release)
 await wait_process_frames(2)
 assert_false(scene._rodeo_unsaved241)
 assert_eq(SaveData.victories240.wins,{"bulls":1})
