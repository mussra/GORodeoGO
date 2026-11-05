extends SceneTree
var title:Label
func _initialize()->void:call_deferred("setup")
func release()->void:
 for action in ["move_left","move_right","move_up","move_down"]:Input.action_release(action)
func setup()->void:
 var save=root.get_node("SaveData");var old_path:String=save.save_path;var old_hat:String=save.hat_color
 save.save_path="user://qa_hat_motion.dat"
 AudioServer.set_bus_mute(0,true)
 var layer:=CanvasLayer.new();layer.layer=100;root.add_child(layer)
 title=Label.new();title.position=Vector2(30,78);title.add_theme_font_size_override("font_size",22);layer.add_child(title)
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();root.add_child(menu)
 await create_timer(.25).timeout
 menu._show_equipment();await process_frame
 for child in menu._equipment_panel._canvas.get_children():
  if child is Button and child.text=="SOMBREROS · PROBAR":child.pressed.emit()
 await process_frame
 var hats=menu._equipment_panel._hats
 title.hide()
 hats._buttons["blue"].pressed.emit()
 await create_timer(1.4).timeout
 menu.free()
 for color in ["blue","sand","original"]:
  save.select_hat(color);save.load_progress()
  root.get_node("GameState").selected_level=1
  var level=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(level)
  await physics_frame
  for bull in level._active_bulls:bull.set_physics_process(false)
  title.show();title.text=HatAppearance.OPTIONS[color]+" · movimiento real en 8 direcciones · prueba aislada"
  var player=level.player
  var directions=[["move_right"],["move_right","move_down"],["move_down"],["move_left","move_down"],["move_left"],["move_left","move_up"],["move_up"],["move_right","move_up"]]
  player.global_position=Vector2.ZERO
  for actions in directions:
   release()
   for action in actions:Input.action_press(action)
   await create_timer(.32).timeout
  release();await create_timer(.35).timeout
  level.free()
 title.hide()
 save.save_path=old_path;save.hat_color=old_hat
 DirAccess.remove_absolute("user://qa_hat_motion.dat")
 quit()
