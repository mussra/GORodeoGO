extends GutTest
var panel:Control
var previous:String
func before_each():
 previous=SaveData.save_path;SaveData.save_path="user://finish145-test.dat";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData._load_valid=true;SaveData.trial_session_active=false
func after_each():
 if is_instance_valid(panel):panel.free()
 SaveData.save_path=previous;await get_tree().process_frame
func test_preview_does_not_write_appearance_stats_inventory_or_disk():
 var before:Dictionary=SaveData.horse_collection.export_state().duplicate(true);var points:int=SaveData.equipment_points;var hat:String=SaveData.hat_color;var owned:Array=SaveData.equipment_owned.duplicate();var existed:bool=FileAccess.file_exists(SaveData.save_path)
 panel=FinishPreview145.new();add_child(panel);await get_tree().process_frame
 assert_eq(panel.runners.size(),3)
 for runner in panel.runners:assert_not_null(runner.texture);assert_not_null(runner.material)
 panel.clocks=8.;panel._advance();assert_eq(panel.frame_id,0)
 assert_eq(SaveData.horse_collection.export_state(),before);assert_eq(SaveData.equipment_points,points);assert_eq(SaveData.hat_color,hat);assert_eq(SaveData.equipment_owned,owned);assert_eq(FileAccess.file_exists(SaveData.save_path),existed)
func test_layout_at_small_landscape_and_back_closes():
 panel=FinishPreview145.new();add_child(panel);await get_tree().process_frame
 panel.size=Vector2(960,540);panel._layout();assert_eq(panel.canvas.scale,Vector2(.75,.75))
 for runner in panel.runners:assert_lte((runner.position.y+runner.size.y)*.75,510.)
 var event:=InputEventAction.new();event.action="ui_cancel";event.pressed=true;panel._unhandled_input(event);assert_true(panel.is_queued_for_deletion());await get_tree().process_frame
func test_equipment_has_preview_entry_without_a_purchase():
 panel=EquipmentPanel.new();add_child(panel);await get_tree().process_frame
 var button:Button
 for child in panel._canvas.get_children():
  if child is Button and child.text=="Acabados · Vista previa":button=child
 assert_not_null(button)
 if button==null:return
 button.pressed.emit();await get_tree().process_frame
 var preview:Control
 for child in panel.get_children():
  if child is FinishPreview145:preview=child
 assert_not_null(preview)
