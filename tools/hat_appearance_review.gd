extends SceneTree
func _initialize()->void:call_deferred("setup")
func shot(path:String)->void:
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(path)
func setup()->void:
 var save=root.get_node("SaveData");var old_path:String=save.save_path
 var old={"hat":save.hat_color,"progress":save.highest_level_completed,"points":save.equipment_points,"owned":save.equipment_owned.duplicate(),"equipped":save.equipment_equipped.duplicate(),"marker":save.points_legacy_credit_applied,"intro":save.dual_lasso_intro_shown}
 save.save_path="user://qa_hat_visual.dat";save.equipment_points=675
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();root.add_child(menu)
 await create_timer(.5).timeout
 menu._show_equipment();await process_frame
 await shot("/downloads/gorodeo/hat-equipment-entry.png")
 for child in menu._equipment_panel._canvas.get_children():
  if child is Button and child.text=="SOMBREROS · PROBAR":child.pressed.emit()
 await process_frame
 var hats=menu._equipment_panel._hats
 hats._buttons["blue"].pressed.emit();await process_frame
 await shot("/downloads/gorodeo/hat-selector-blue.png")
 menu.free()
 for color in ["blue","sand","original"]:
  save.select_hat(color);save.load_progress()
  var level=load("res://src/Presentation/level_0.tscn").instantiate();root.get_node("GameState").selected_level=1;root.add_child(level)
  await create_timer(.5).timeout
  var player=level.get_node("Player")
  player._sprite_swap.play("walk_side")
  player.set_physics_process(false)
  for bull in level._active_bulls:bull.set_physics_process(false)
  await create_timer(.2).timeout
  await shot("/downloads/gorodeo/hat-ingame-"+color+".png")
  print("HAT_REVIEW ",save.hat_color," points=",save.equipment_points," texture=",player._sprite_swap._frames.get_frame_texture("walk_side",0).resource_path)
  level.free()
 save.save_path=old_path;save.hat_color=old.hat;save.highest_level_completed=old.progress;save.equipment_points=old.points;save.equipment_owned.assign(old.owned);save.equipment_equipped=old.equipped;save.points_legacy_credit_applied=old.marker;save.dual_lasso_intro_shown=old.intro
 DirAccess.remove_absolute("user://qa_hat_visual.dat")
 quit()
