extends GutTest
var old_progress:int
var old_debug239:bool
func before_each()->void:
 SaveData.end_trial_session();old_progress=SaveData.highest_level_completed;old_debug239=SaveData.debug_mode;SaveData.debug_mode=false
func after_each()->void:
 SaveData.highest_level_completed=old_progress;SaveData.debug_mode=old_debug239
 Engine.time_scale=1.0
 for action in ["move_left","move_right","move_up","move_down"]:Input.action_release(action)
func test_menu_has_no_debug_unlock_and_never_resets_existing_progress()->void:
 for highest in [0,3,10,20]:
  SaveData.highest_level_completed=highest
  var menu=load("res://src/Presentation/main_menu.tscn").instantiate()
  add_child(menu)
  await get_tree().process_frame
  for i in range(20):
   var b:Button=menu.level_grid.get_child(i)
   var locked:bool=b.disabled
   for child in menu.get_children():
    if child is MenuInputGuard and child.saved.has(b):locked=child.saved[b].disabled
   assert_eq(locked,i>highest,"level "+str(i+1)+" / progress "+str(highest))
  assert_eq(SaveData.highest_level_completed,highest)
  if highest==0:
   menu._on_level_selected(20)
   assert_false(menu._transitioning,"disabled level cannot be launched through handler either")
  menu.free()

