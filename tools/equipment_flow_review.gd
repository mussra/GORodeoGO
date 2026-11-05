extends SceneTree
func _initialize()->void:call_deferred("setup")
func shot(path:String)->void:
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(path)
func setup()->void:
 var save=root.get_node("SaveData");var old_path:String=save.save_path
 var old={"progress":save.highest_level_completed,"points":save.equipment_points,"owned":save.equipment_owned.duplicate(),"equipped":save.equipment_equipped.duplicate(),"marker":save.points_legacy_credit_applied,"intro":save.dual_lasso_intro_shown}
 save.save_path="user://qa_equipment_visual.dat"
 save.highest_level_completed=10;save.equipment_points=0;save.equipment_owned.clear();save.equipment_equipped.clear();save.points_legacy_credit_applied=false;save.dual_lasso_intro_shown=true
 save.apply_legacy_points_credit(EquipmentCatalog.REWARDS)
 root.get_node("GameState").selected_level=1
 root.get_node("GameState").brand_intro_played=true
 var level=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(level)
 await physics_frame
 level._trigger_win()
 await create_timer(.3).timeout
 await shot("/downloads/gorodeo/equipment-victory.png")
 level.free()
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();root.add_child(menu)
 await create_timer(.8).timeout
 menu._show_equipment()
 await create_timer(.2).timeout
 await shot("/downloads/gorodeo/equipment-live-before.png")
 menu._equipment_panel._buy["whip_basic"].pressed.emit()
 menu._equipment_panel._equip["whip_basic"].pressed.emit()
 menu._equipment_panel._buy["whip_long"].pressed.emit()
 menu._equipment_panel._equip["whip_long"].pressed.emit()
 save.load_progress()
 menu._equipment_panel.refresh()
 await create_timer(.2).timeout
 await shot("/downloads/gorodeo/equipment-live-after.png")
 print("EQUIPMENT_VISUAL_FLOW ",save.equipment_points," reach=",save.equipped_whip_reach()," progress=",save.highest_level_completed)
 menu.free()
 save.save_path=old_path;save.highest_level_completed=old.progress;save.equipment_points=old.points;save.equipment_owned.assign(old.owned);save.equipment_equipped=old.equipped;save.points_legacy_credit_applied=old.marker;save.dual_lasso_intro_shown=old.intro
 DirAccess.remove_absolute("user://qa_equipment_visual.dat")
 quit()
