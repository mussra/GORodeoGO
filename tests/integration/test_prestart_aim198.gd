extends GutTest
var scene:Node2D
func after_each():
 if is_instance_valid(scene):scene.free()
 for action in ["throw_lasso","aim_right","move_right"]:Input.action_release(action)
 get_tree().paused=false;Engine.time_scale=1.;await wait_physics_frames(2)
func make_scene(path:String):
 RaceCourse190.selected=0;RaceCourse190.start_selected=true
 scene=load(path).instantiate();add_child(scene);await wait_physics_frames(2)
 for rider in scene.riders:
  if rider!=scene.player:rider.set_physics_process(false)
func check_countdown():
 var p=scene.player;var from:Vector2=p.position
 p.lasso._on_aim_pressed();Input.action_press("aim_right",.8);await wait_physics_frames(6)
 assert_true(p.lasso.is_charging());assert_gt(p.lasso.charge_distance(),10.)
 assert_eq(p.position,from);assert_false(p.lasso.is_in_flight())
 # Early release cancels; no queued automatic launch at start.
 p.lasso._on_aim_released(Vector2.RIGHT*.8)
 assert_false(p.lasso.is_in_flight());assert_false(p.lasso.is_charging())
 scene.countdown=0.;scene.running=true;await wait_physics_frames(3)
 assert_false(p.lasso.is_in_flight())
 # New countdown, held aim carries through GO and needs a release.
 scene.running=false;scene.countdown=1.
 p.lasso._on_aim_pressed();await wait_physics_frames(3)
 scene.countdown=0.;scene.running=true;await wait_physics_frames(3)
 assert_true(p.lasso.is_charging());assert_false(p.lasso.is_in_flight())
 p.lasso._on_aim_released(Vector2.RIGHT*.8)
 assert_true(p.lasso.is_in_flight())
func test_race_prestart_aim_without_launch_or_movement():
 await make_scene("res://src/Presentation/race190.tscn");await check_countdown()
 assert_true(scene.player.dodge.available)
func test_joust_prestart_aim_without_launch_or_movement():
 await make_scene("res://src/Presentation/joust196.tscn");await check_countdown()
 assert_true(scene.player.dodge.available)
func test_free_duel_still_has_dodge_and_no_new_prestart_aim():
 await make_scene("res://src/Presentation/duel193.tscn")
 assert_true(scene.player.dodge.available)
 scene.player.lasso._on_aim_pressed();await wait_physics_frames(2)
 assert_false(scene.player.lasso.is_charging())

func test_countdown_shows_three_two_one_and_go_without_blocking_input():
 await make_scene("res://src/Presentation/joust196.tscn")
 var counter=scene.hud.get_node("StartCountdown198")
 for value in [3.,2.,1.]:
  scene.countdown=value;counter._process(0.)
  assert_eq(counter.text,str(int(value)));assert_true(counter.visible)
 assert_eq(counter.mouse_filter,Control.MOUSE_FILTER_IGNORE)
 scene.countdown=0.;scene.running=true;counter._process(.01)
 assert_eq(counter.text,"¡YA!")

func _ignore(node:Node):
 if node is Control:node.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for child in node.get_children():_ignore(child)
func touch(index:int,p:Vector2,pressed:bool):
 var e:=InputEventScreenTouch.new();e.index=index;e.position=p;e.pressed=pressed;Input.parse_input_event(e);Input.flush_buffered_events()
func test_native_prestart_aim_and_double_tap_no_regate_in_joust():
 _ignore(get_tree().root.get_node("GutRunner"))
 await make_scene("res://src/Presentation/joust196.tscn")
 var size:Vector2=get_viewport().get_visible_rect().size;var right:Vector2=size*Vector2(.76,.78);var left:Vector2=size*Vector2(.16,.78)
 touch(0,left,true);await wait_physics_frames(1);touch(0,left,false);await wait_physics_frames(1);touch(0,left,true)
 assert_false(scene.player.dodge.drawing);assert_eq(Engine.time_scale,1.)
 touch(1,right,true);await wait_physics_frames(2)
 var drag:=InputEventScreenDrag.new();drag.index=1;drag.position=right+Vector2(70,0);Input.parse_input_event(drag);Input.flush_buffered_events();await wait_physics_frames(3)
 assert_true(scene.player.lasso.is_charging());assert_gt(scene.player.lasso.charge_distance(),10.)
 assert_false(scene.running);assert_false(scene.player.lasso.is_in_flight())
 scene.countdown=0.;scene.running=true;await wait_physics_frames(2)
 touch(1,right+Vector2(70,0),false);await wait_physics_frames(2)
 assert_true(scene.player.lasso.is_in_flight());touch(0,left,false)
