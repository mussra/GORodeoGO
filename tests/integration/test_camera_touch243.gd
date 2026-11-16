extends "res://tests/integration/test_touch_lost224.gd"
var toolbar:WorldCamera243
func before_each():
 await super.before_each()
 var layer:=CanvasLayer.new();layer.layer=20;host.add_child(layer)
 toolbar=WorldCamera243.new();toolbar.camera=Camera2D.new();host.add_child(toolbar.camera)
 layer.add_child(toolbar);toolbar.set_process(false);toolbar.set_factor(1.,false)
 await wait_process_frames(3)
func after_each():
 await super.after_each();DirAccess.remove_absolute(WorldCamera243.PREF_PATH)
func test_camera_tap_is_ui_not_lasso_and_keeps_held_move():
 await start()
 var point:Vector2=toolbar.minus.get_global_rect().get_center()
 touch(point,true,1);await wait_process_frames(2);touch(point,false,1);await wait_process_frames(5)
 assert_almost_eq(toolbar.factor,.85,.001)
 assert_gt(moving().length(),.1);assert_false(player.lasso.is_charging());assert_false(player.lasso.is_in_flight());assert_false(player.dodge.drawing)
 touch(Vector2(30,420),false,0);await wait_physics_frames(20);assert_eq(moving(),Vector2.ZERO)
func test_camera_reset_tap_restores_one_without_moving_or_throwing():
 toolbar.set_factor(.75,false)
 var point:Vector2=toolbar.reset.get_global_rect().get_center()
 touch(point,true,1);await wait_process_frames(2);touch(point,false,1);await wait_process_frames(5)
 assert_eq(toolbar.factor,1.);assert_eq(moving(),Vector2.ZERO);assert_false(player.lasso.is_in_flight())
func test_wall_collision_has_same_world_contact_at_both_zooms():
 var wall:=StaticBody2D.new();wall.position=Vector2(200,0);wall.collision_layer=128;wall.collision_mask=0
 var shape:=CollisionShape2D.new();var box:=RectangleShape2D.new();box.size=Vector2(20,200);shape.shape=box;wall.add_child(shape);host.add_child(wall)
 player.set_physics_process(false);await wait_physics_frames(2)
 var contacts:Array[Vector2]=[]
 for factor in [1.,.75]:
  toolbar.set_factor(factor,false);player.position=Vector2.ZERO
  var hit:KinematicCollision2D=player.move_and_collide(Vector2(500,0))
  assert_not_null(hit)
  if hit!=null:assert_eq(hit.get_collider(),wall)
  contacts.append(player.position)
 assert_almost_eq(contacts[0].x,contacts[1].x,.01)
 assert_lt(contacts[0].x,190.)
