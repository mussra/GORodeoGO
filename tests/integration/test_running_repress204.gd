extends GutTest
var host:Node
var rider:Node
func after_each():
 if is_instance_valid(host):host.free()
 for action in ["move_up","move_down","move_left","move_right"]:Input.action_release(action)
 Engine.time_scale=1.;get_tree().paused=false
 await wait_physics_frames(2)
func make_world():
 host=Node2D.new();add_child(host)
 rider=load("res://src/Presentation/world_player.gd").new();host.add_child(rider)
 await wait_physics_frames(2)
func make_mode(mode:String):
 RaceCourse190.start_selected=true;RaceCourse190.selected=0
 host=load("res://src/Presentation/"+mode+".tscn").instantiate();add_child(host)
 await wait_physics_frames(2)
 host.countdown=0.;host.running=true;rider=host.player
 for p in host.riders:p.set_physics_process(false)
func running_lift():
 rider.dodge.on_move_pressed();rider.dodge.move_pressed_at-=5.
 rider.velocity=Vector2(200,0);rider.dodge.on_move_released(Vector2.RIGHT)
func check_arm_and_execute():
 running_lift();rider.dodge.on_move_pressed()
 assert_true(rider.dodge.drawing,"one re-press after a long running hold")
 assert_eq(Engine.time_scale,DodgeController.DRAW_TIME_SCALE)
 rider.dodge.draw_points=PackedVector2Array([Vector2.ZERO,Vector2(80,0)])
 rider.dodge.on_move_released(Vector2.RIGHT)
 assert_false(rider.dodge.path.is_empty());assert_eq(Engine.time_scale,1.)
func test_frontier_shared_body_long_hold_single_repress():
 await make_world();check_arm_and_execute()
func test_race_long_hold_single_repress():
 await make_mode("race190");check_arm_and_execute()
func test_free_duel_long_hold_single_repress():
 await make_mode("duel193");check_arm_and_execute()
func test_joust_running_repress_enabled_but_not_during_preparation():
 await make_mode("joust196");check_arm_and_execute()
 rider.cancel_input();rider.dodge.cooldown=0.;host.running=false
 running_lift();rider.dodge.on_move_pressed();assert_false(rider.dodge.drawing)
func test_timeout_cooldown_stun_and_cancel_still_block():
 await make_world()
 running_lift();rider.dodge.running_release_at-=.31;rider.dodge.on_move_pressed();assert_false(rider.dodge.drawing)
 rider.cancel_input();running_lift();rider.dodge.cooldown=1.;rider.dodge.on_move_pressed();assert_false(rider.dodge.drawing)
 rider.cancel_input();rider.dodge.cooldown=0.;running_lift();rider._stun_time_remaining=1.;rider.dodge.on_move_pressed();assert_false(rider.dodge.drawing)
 rider._stun_time_remaining=0.;rider.cancel_input();running_lift();rider.cancel_input();rider.dodge.on_move_pressed();assert_false(rider.dodge.drawing)
func ignore(node:Node):
 if node is Control:node.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for c in node.get_children():ignore(c)
func touch(pressed:bool):
 var e:=InputEventScreenTouch.new();e.index=0;e.position=Vector2(200,530);e.pressed=pressed;Input.parse_input_event(e);Input.flush_buffered_events()
func drag():
 var e:=InputEventScreenDrag.new();e.index=0;e.position=Vector2(280,530);Input.parse_input_event(e);Input.flush_buffered_events()
func test_native_running_lift_and_repress_in_world_and_race():
 ignore(get_tree().root.get_node("GutRunner"))
 for mode in ["world","race190"]:
  if mode=="world":
   await make_world()
   var controls=load("res://src/Presentation/touch_controls.tscn").instantiate();host.add_child(controls)
   rider.dodge.set_move_joystick(controls.get_node("MoveJoystick"))
  else:await make_mode(mode)
  touch(true);await wait_physics_frames(2);drag();await wait_physics_frames(4)
  rider.dodge.move_pressed_at-=5.;rider.velocity=Vector2(200,0)
  touch(false);await wait_physics_frames(1);touch(true)
  assert_true(rider.dodge.drawing,"native "+mode+" re-press arms without another tap")
  drag();await wait_physics_frames(1);touch(false)
  assert_false(rider.dodge.path.is_empty(),"native "+mode+" release executes")
  host.free();host=null;rider=null
  Engine.time_scale=1.;await wait_physics_frames(2)

func test_shared_clock_fraction_and_joust_backwards_path_does_not_stick():
 assert_eq(DodgeVisuals.clock_fraction204(2.5,2.5),0.)
 assert_eq(DodgeVisuals.clock_fraction204(1.25,2.5),.5)
 assert_eq(DodgeVisuals.clock_fraction204(0.,2.5),1.)
 await make_mode("joust196")
 assert_true(rider.dodge.request_path(PackedVector2Array([Vector2.ZERO,Vector2(-120,0)])))
 rider._physics_process(.1)
 assert_true(rider.dodge.path.is_empty(),"clipped backwards sprint cancels cleanly, no refund")
 assert_gt(rider.dodge.cooldown,0.)
func test_actual_frontier_after_streaming_uses_running_repress():
 var old_path:String=SaveData.save_path;SaveData.save_path="user://regate204-fixture.cfg"
 SaveData.world_seed=424242;SaveData.world_position=Vector2(0,600)
 SaveData.country_ledger146["active"]="frontier"
 host=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(host)
 for i in 600:
  await wait_frames(1)
  if not host._loading_world:break
 assert_false(host._loading_world,"actual Frontera streaming completed")
 rider=host.player
 assert_true(rider.is_physics_processing())
 running_lift();rider.dodge.on_move_pressed()
 assert_true(rider.dodge.drawing,"actual Frontera same long-hold gesture")
 rider.cancel_input();host.free();host=null;rider=null
 SaveData.save_path=old_path
