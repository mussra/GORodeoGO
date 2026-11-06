extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var save:Node=root.get_node("SaveData");save.save_path="user://trial_restart_evidence.dat"
 if "prepare" in OS.get_cmdline_user_args():
  save.highest_level_completed=3;save.equipment_points=77;save.save_progress()
  var before:PackedByteArray=FileAccess.get_file_as_bytes(save.save_path)
  assert(save.begin_trial_session());save.preview_trial_traits(19,4,5);save.equip_item("whip_long");save.record_victory(20);save.save_progress()
  assert(FileAccess.get_file_as_bytes(save.save_path)==before)
  print("PROCESS1_BYTES ",before.hex_encode().sha256_text())
 else:
  save.load_progress();assert(not save.trial_session_active);assert(save.highest_level_completed==3);assert(save.equipment_points==77);assert(save.horse_collection.find("preview_temporary").is_empty())
  print("PROCESS2_BYTES ",FileAccess.get_file_as_bytes(save.save_path).hex_encode().sha256_text())
 quit()
