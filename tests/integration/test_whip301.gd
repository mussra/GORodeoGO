extends "res://tests/integration/test_touch_lost224.gd"
var whip:ScareButton265
var old_equipped:Dictionary
var old_owned:Array
func before_each():
 old_equipped=SaveData.equipment_equipped.duplicate(true);old_owned=SaveData.equipment_owned.duplicate()
 SaveData.equipment_owned.append("scare_whip265");SaveData.equipment_equipped.scare_whip="scare_whip265"
 await super.before_each()
 var layer:=CanvasLayer.new();layer.layer=20;host.add_child(layer)
 whip=ScareButton265.new();whip.player=player;layer.add_child(whip)
 await wait_process_frames(4)
func after_each():
 await super.after_each()
 SaveData.equipment_equipped=old_equipped;SaveData.equipment_owned=old_owned
func test_second_finger_crack_while_moving_keeps_move_and_never_aims():
 await start()
 assert_true(whip.can_activate265())
 var point:=whip.get_global_rect().get_center()
 touch(point,true,1);await wait_process_frames(2)
 touch(point,false,1);await wait_process_frames(4)
 assert_gt(whip.cooldown265,4.)
 assert_gt(moving().length(),.1)
 assert_false(player.lasso.is_charging());assert_false(player.lasso.is_in_flight());assert_false(player.dodge.drawing)
 touch(Vector2(30,420),false,0);await wait_physics_frames(20);assert_eq(moving(),Vector2.ZERO)
func test_second_finger_natural_drift_inside_button_is_still_action():
 await start()
 var point:=whip.get_global_rect().get_center()
 touch(point,true,1);await wait_process_frames(2)
 drag(point+Vector2(18,3),1);await wait_process_frames(3)
 touch(point+Vector2(18,3),false,1);await wait_process_frames(4)
 assert_gt(whip.cooldown265,4.)
 assert_gt(moving().length(),.1)
 assert_false(player.lasso.is_charging());assert_false(player.lasso.is_in_flight())
func test_layout_tracks_widescreen_tablet_and_safe_insets():
 for extent in [Vector2(1280,720),Vector2(1600,720),Vector2(1920,864),Vector2(1280,960)]:
  var at:=ScareButton265.placement301(extent)
  assert_eq(at.x+112.,extent.x-16.)
  assert_gte(at.y,90.);assert_lte(at.y+112.,extent.y-98.)
  assert_false(Rect2(at,Vector2(112,112)).intersects(Rect2(956,636,76,76)))
  for x in [1046,1130,1214]:assert_false(Rect2(at,Vector2(112,112)).intersects(Rect2(x,636,76,76)))
 var safe:=Rect2(40,0,1520,720)
 var at:=ScareButton265.placement301(Vector2(1600,720),safe)
 assert_eq(at.x+112.,1544.)
func test_button_drag_does_not_charge_lasso_and_outside_release_cancels_only_that_finger():
 await start()
 var point:=whip.get_global_rect().get_center()
 touch(point,true,1);await wait_process_frames(2)
 drag(point-Vector2(180,0),1);await wait_process_frames(3)
 touch(point-Vector2(180,0),false,1);await wait_process_frames(3)
 assert_eq(whip.cooldown265,0.);assert_gt(moving().length(),.1)
 assert_false(player.lasso.is_charging());assert_false(player.lasso.is_in_flight())
func test_button_cancel_does_not_activate_or_steal_held_movement():
 await start()
 var point:=whip.get_global_rect().get_center()
 touch(point,true,1);await wait_process_frames(2)
 touch(point,false,1,true);await wait_process_frames(3)
 assert_eq(whip.cooldown265,0.);assert_gt(moving().length(),.1)
