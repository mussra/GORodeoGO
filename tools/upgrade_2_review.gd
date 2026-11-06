extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var sd:Node=root.get_node("SaveData");sd.save_path="user://upgrade41to2.dat"
 var cfg:=ConfigFile.new();cfg.set_value("meta","version",2);cfg.set_value("progress","highest_level_completed",18);cfg.set_value("progress","dual_lasso_intro_shown",true);cfg.set_value("appearance","hat_color","blue");cfg.set_value("equipment","points",517);cfg.set_value("equipment","legacy_credit_applied",true)
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();c.selected="trial_b";c.find("trial_a").name="Mi caballo antiguo";cfg.set_value("horses_trial","state",c.export_state());assert(cfg.save(sd.save_path)==OK)
 sd.load_progress();assert(sd.highest_level_completed==18);assert(sd.equipment_points==517);assert(sd.hat_color=="blue");assert(sd.horse_collection.selected=="trial_b");assert(sd.horse_collection.find("trial_a").name=="Mi caballo antiguo");assert(sd.horse_collection.horses.size()==3)
 assert(sd.save_progress());sd.load_progress();assert(sd.horse_collection.horses.size()==3);assert(sd.equipment_points==517);print("UPGRADE_41_TO_2_SAVE_SCHEMA_PASS")
 DirAccess.remove_absolute(sd.save_path);quit()
