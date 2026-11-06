extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var save:Node=root.get_node("SaveData");save.save_path="user://qa_menu_process_restart.dat"
 var writing:bool=OS.get_cmdline_user_args().has("write")
 if writing:
  save.horse_collection=HorseCollection.new();save.horse_collection.seed_trial();save.horse_collection.add_trial_parents()
  save.equipment_owned.assign(["whip_basic","whip_long"]);save.equipment_equipped={"whip":"whip_long"};save.select_horse("trial_b");save.select_hat("blue");assert(save.save_progress())
  print("PROCESS1 SAVED horse=trial_b hat=blue whip=whip_long")
 else:
  save.load_progress();assert(save.horse_collection.selected=="trial_b");assert(save.hat_color=="blue");assert(save.equipment_equipped.whip=="whip_long")
  root.get_node("GameState").brand_intro_played=true
  var menu:Node=load("res://src/Presentation/main_menu.tscn").instantiate();root.add_child(menu)
  await create_timer(1.2).timeout;menu._hero.modulate.a=1
  assert(menu._hd_rider.material.get_shader_parameter("rainbow"));assert(not menu._hd_rider.material.get_shader_parameter("original_hat"))
  await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/menu-process-restart39.png")
  print("PROCESS2 LOADED selected portrait/hat and whip PASS")
  DirAccess.remove_absolute(save.save_path)
 quit()
