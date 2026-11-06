extends SceneTree
func _initialize()->void:
 var path:="user://eyes-schema-review.cfg"
 if "--verify-eyes" in OS.get_cmdline_user_args():
  var config:=ConfigFile.new();assert(config.load(path)==OK);var c:=HorseCollection.new();assert(c.restore(config.get_value("horses_trial","state")));assert(c.find("random_trial_4").traits.eyes==3);DirAccess.remove_absolute(path);print("EYES_PROCESS_RESTART_PASS")
 else:
  var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();var pair:=c.add_random_trial_pair();pair[0].traits.eyes=3;var config:=ConfigFile.new();config.set_value("horses_trial","state",c.export_state());assert(config.save(path)==OK);print("EYES_PROCESS_SAVE_PASS")
 quit()
