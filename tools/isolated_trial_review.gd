extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var SaveData:Node=root.get_node("SaveData");var GameState:Node=root.get_node("GameState")
 var original_path:String=SaveData.save_path
 SaveData.save_path="user://isolated_trial_video.dat";SaveData.save_progress()
 var bytes:PackedByteArray=FileAccess.get_file_as_bytes(SaveData.save_path)
 GameState.brand_intro_played=true
 var menu:Node=load("res://src/Presentation/main_menu.tscn").instantiate();root.add_child(menu);current_scene=menu
 for i in range(35):await process_frame
 assert(SaveData.begin_trial_session())
 var panel:Node=load("res://src/Presentation/trial_panel.gd").new();menu.add_child(panel)
 for i in range(50):await process_frame
 root.get_texture().get_image().save_png("/downloads/isolated-trial-panel.png")
 panel.picks[0].select(19);panel.picks[1].select(4);panel.picks[2].select(5)
 for b in panel.canvas.get_children():
  if b is Button and b.text=="USAR ASPECTO TEMPORAL":b.pressed.emit()
 for pick in panel.canvas.get_children():
  if pick is OptionButton and pick.item_count==2:pick.select(1);pick.item_selected.emit(1)
 panel.refresh()
 for i in range(60):await process_frame
 GameState.selected_level=5
 change_scene_to_file("res://src/Presentation/level_0.tscn")
 for i in range(40):await process_frame
 var level:Node=current_scene
 for b in level._active_bulls:b.set_physics_process(false)
 level.player.global_position=Vector2(0,140)
 # Invoke actual dodge path and motor input: not physical Android gestures.
 Input.action_press("move_right")
 assert(level.player.request_dodge_path(PackedVector2Array([Vector2.ZERO,Vector2(0,-220),Vector2(160,-220)])))
 for i in range(75):await physics_frame
 Input.action_release("move_right")
 root.get_texture().get_image().save_png("/downloads/isolated-trial-regate.png")
 level._trigger_win() # checks reward gate, not evidence of natural victory
 assert(FileAccess.get_file_as_bytes(SaveData.save_path)==bytes)
 change_scene_to_file("res://src/Presentation/main_menu.tscn")
 for i in range(50):await process_frame
 assert(not SaveData.trial_session_active);assert(FileAccess.get_file_as_bytes(SaveData.save_path)==bytes)
 print("ISOLATED_SESSION_BYTES_UNCHANGED ",bytes.size())
 root.get_texture().get_image().save_png("/downloads/isolated-trial-restored.png")
 SaveData.save_path=original_path;quit()
