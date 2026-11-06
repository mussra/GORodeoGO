extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var save=root.get_node("SaveData");save.save_path="user://qa_stats.dat";save.horse_collection=HorseCollection.new();save.horse_collection.seed_trial();save.horse_collection.add_trial_parents()
 var h:Dictionary=save.breed_horses("trial_a","trial_b",{});save.mature_horse_trial(h.id);save.select_horse(h.id);save.equipment_owned.assign(["whip_basic"]);save.equipment_equipped={"whip":"whip_basic"};save.highest_level_completed=5
 root.get_node("GameState").selected_level=1
 var level=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(level);await physics_frame
 var p=level.player
 assert(is_equal_approx(p.max_speed,322.0));assert(is_equal_approx(p.acceleration,1250.0));assert(is_equal_approx(p.dual_capture_speed_multiplier,.8));assert(is_equal_approx(p.dodge_path_limit,260.0));assert(p._max_captures==2)
 p.set_active_capture_count(2)
 print("HORSE_RUNTIME_STATS_PASSED speed=",p.max_speed," acceleration=",p.acceleration," tow=",p.dual_capture_speed_multiplier," reach=",p.dodge_path_limit," capacity=",p._max_captures)
 level.free();DirAccess.remove_absolute("user://qa_stats.dat");quit()
