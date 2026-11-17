extends GutTest
var old_debug:bool
var old_path:String
var old_history:Dictionary
func before_each()->void:
 old_debug=SaveData.debug_mode;old_path=SaveData.save_path;old_history=SaveData.victories240.duplicate(true)
 SaveData.debug_mode=true;SaveData.save_path="user://mode-hooks240.cfg";SaveData.victories240=ModeVictories240.fresh();SaveData.pending_victory240.clear()
func after_each()->void:
 SaveData.debug_mode=old_debug;SaveData.save_path=old_path;SaveData.victories240=old_history;SaveData.pending_victory240.clear()
 if FileAccess.file_exists("user://mode-hooks240.cfg"):DirAccess.remove_absolute("user://mode-hooks240.cfg")
func test_completed_duel_records_once_not_per_manga()->void:
 var scene:Node=load("res://src/Presentation/duel193.tscn").instantiate();add_child(scene);scene.set_physics_process(false)
 scene.pending.clear();scene.pending.append(0);scene._resolve_round();assert_eq(SaveData.victories240.wins,{})
 scene.pending.clear();scene.pending.append(0);scene._resolve_round();assert_eq(SaveData.victories240.wins,{"duel":1});assert_eq(scene.get_children().filter(func(c):return c is HorseVictory251).size(),1)
 scene.free()
func test_justa_records_as_justa_never_duel()->void:
 var scene:Node=load("res://src/Presentation/joust196.tscn").instantiate();add_child(scene);scene.set_physics_process(false)
 scene.pending.clear();scene.pending.append(0);scene._resolve_round();scene.pending.clear();scene.pending.append(0);scene._resolve_round()
 assert_eq(SaveData.victories240.wins,{"joust":1});assert_eq(scene.get_children().filter(func(c):return c is HorseVictory251).size(),1);scene.free()
func test_rival_win_never_counts()->void:
 var scene:Node=load("res://src/Presentation/duel193.tscn").instantiate();add_child(scene);scene.set_physics_process(false)
 scene.pending.clear();scene.pending.append(1);scene._resolve_round();scene.pending.clear();scene.pending.append(1);scene._resolve_round()
 assert_eq(SaveData.victories240.wins,{});scene.free()
func test_first_race_win_records_course_and_reopening_finish_is_not_two_wins()->void:
 var scene:Node=load("res://src/Presentation/race190.tscn").instantiate();add_child(scene);scene.set_physics_process(false)
 for i in 4:scene.riders[i].finish_time=50.+i;scene.riders[i].next_gate=17
 scene._finish();scene._finish()
 assert_eq(SaveData.victories240.wins,{"race":1});assert_eq(SaveData.victories240.courses,{"0":1});assert_eq(scene.get_children().filter(func(c):return c is HorseVictory251).size(),1);scene.free()
