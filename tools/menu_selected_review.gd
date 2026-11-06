extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var save:Node=root.get_node("SaveData");var path:String=save.save_path
 save.save_path="user://qa_menu_selected.dat";save.horse_collection=HorseCollection.new();save.horse_collection.seed_trial();save.horse_collection.add_trial_parents();save.select_horse("trial_b");save.select_hat("blue")
 root.get_node("GameState").brand_intro_played=true
 var menu:Control=load("res://src/Presentation/main_menu.tscn").instantiate();root.add_child(menu)
 for i in range(10):await process_frame
 menu._hero.modulate.a=1
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/menu-selected39.png")
 var m:ShaderMaterial=menu._hd_rider.material
 assert(m.get_shader_parameter("rainbow")==true)
 save.select_horse("trial_a");menu._refresh_points_caption();assert(menu._hd_rider.material.get_shader_parameter("rainbow")==false)
 save.load_progress();assert(save.horse_collection.selected=="trial_a");assert(save.hat_color=="blue")
 assert(save.begin_trial_session());save.select_horse("trial_b");save.end_trial_session();assert(save.horse_collection.selected=="trial_a")
 save.load_progress();assert(save.horse_collection.selected=="trial_a")
 print("MENU_SELECTION normal return/reload and isolated trial restoration PASS")
 DirAccess.remove_absolute(save.save_path);save.save_path=path;menu.queue_free();await process_frame;quit()
