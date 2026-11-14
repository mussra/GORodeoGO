extends GutTest
var scene:Node
var old_path:String
func before_each():old_path=SaveData.save_path;SaveData.save_path="user://memory207-never-save.cfg"
func after_each():
 if is_instance_valid(scene):scene.free()
 get_tree().paused=false;Engine.time_scale=1.;SaveData.save_path=old_path
 for a in ["move_right","move_up","move_down","move_left"]:Input.action_release(a)
func make_scene():
 scene=load("res://src/Presentation/jump_memory207.tscn").instantiate();add_child(scene);await wait_physics_frames(2)
func test_sequence_grows_and_success_six_rounds():
 var game:=JumpMemory207.new(207)
 for round_index in 6:
  var previous:Array=game.sequence.duplicate();game.next_round()
  assert_eq(game.sequence.size(),round_index+1)
  assert_eq(game.sequence.slice(0,previous.size()),previous)
  assert_eq(game.land(0),"show","cannot answer during demonstration")
  game.begin_input()
  for value in game.sequence:game.land(value)
  assert_eq(game.state,"won" if round_index==5 else "passed")
func test_wrong_order_and_repeat_preserves_sequence():
 var game:=JumpMemory207.new(207);game.next_round();game.next_round();game.begin_input()
 var original:Array=game.sequence.duplicate()
 assert_eq(game.land((game.sequence[0]+1)%4),"failed")
 game.repeat();assert_eq(game.sequence,original);assert_eq(game.cursor,0)
func test_scene_observation_freezes_rider_then_allows_navigation():
 await make_scene()
 assert_false(scene.player.is_physics_processing());assert_true(scene.action.visible)
 scene._action();assert_eq(scene.model.state,"show")
 var from:Vector2=scene.player.position
 Input.action_press("move_right");await wait_physics_frames(3);assert_eq(scene.player.position,from)
 scene._physics_process(2.);assert_eq(scene.model.state,"ride")
 await wait_physics_frames(12);assert_gt(scene.player.position.x,from.x)
 assert_false(scene.player.dodge.available);assert_true(scene.player.can_jump)
 assert_true(scene.map_view.visible)
func test_real_shared_jump_over_requested_fence_counts_once():
 await make_scene()
 scene.model.sequence.assign([0]);scene.model.begin_input();scene._refresh()
 scene.player.position=Vector2(350,380)
 # Existing shared jump, crossing the real fence collider, real completion signal.
 assert_true(scene.player.request_jump(Vector2.UP))
 await wait_seconds(.8)
 assert_eq(scene.model.state,"passed");assert_eq(scene.model.cursor,1)
 assert_false(FileAccess.file_exists(SaveData.save_path))
func test_wrong_real_fence_jump_fails_without_progress_write():
 await make_scene();scene.model.sequence.assign([1]);scene.model.begin_input();scene._refresh();scene.player.position=Vector2(350,380)
 assert_true(scene.player.request_jump(Vector2.UP));await wait_seconds(.8)
 assert_eq(scene.model.state,"failed")
 scene._action();assert_eq(scene.model.sequence,[1]);assert_eq(scene.model.state,"show")
func test_pause_and_repeat_cancel_input():
 await make_scene();scene.model.sequence.assign([0,2]);scene.model.begin_input();scene._refresh()
 scene._pause();assert_true(get_tree().paused);assert_true(scene.pause_panel.visible)
 scene._resume();assert_false(get_tree().paused);scene._repeat();assert_false(scene.player.is_physics_processing())
func test_approaching_fence_jumps_automatically_with_shared_movement():
 await make_scene();scene.model.sequence.assign([0]);scene.model.begin_input();scene._refresh()
 scene.player.position=Vector2(350,415)
 watch_signals(scene.player);Input.action_press("move_up")
 await wait_seconds(1.5)
 assert_signal_emitted(scene.player,"jump_started")
 assert_eq(scene.model.state,"passed")
func test_actual_touch_joystick_moves_rider_and_pause_freezes_sequence():
 var runner=get_tree().root.get_node("GutRunner")
 ignore_controls(runner)
 await make_scene();scene.model.sequence.assign([0,1]);scene.model.begin_input();scene._refresh()
 var before:Vector2=scene.player.position
 var e:=InputEventScreenTouch.new();e.index=0;e.position=Vector2(150,430);e.pressed=true;Input.parse_input_event(e);Input.flush_buffered_events();await wait_physics_frames(2)
 var d:=InputEventScreenDrag.new();d.index=0;d.position=Vector2(240,430);Input.parse_input_event(d);Input.flush_buffered_events();await wait_physics_frames(12)
 assert_gt(scene.player.position.x,before.x)
 e.pressed=false;Input.parse_input_event(e);Input.flush_buffered_events()
 scene._repeat();scene._pause();var clock:float=scene.show_clock
 await get_tree().create_timer(.15,true).timeout
 assert_eq(scene.show_clock,clock);scene._resume()
func ignore_controls(node:Node):
 if node is Control:node.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for c in node.get_children():ignore_controls(c)
func test_cancelling_jump_does_not_count_a_partial_crossing():
 await make_scene();scene.model.sequence.assign([0]);scene.model.begin_input();scene._refresh()
 scene.player.position=Vector2(350,380);scene.player.request_jump(Vector2.UP)
 await wait_physics_frames(20)
 scene._pause();assert_eq(scene.model.cursor,0);scene._resume()
func test_each_fence_reachable_automatically_in_both_directions():
 await make_scene()
 for index in 4:
  for direction in [-1.,1.]:
   scene.model.sequence.assign([index]);scene.model.begin_input();scene._refresh()
   scene.player.cancel_input();scene.player._jump_cooldown=0.
   scene.player.position=scene.POINTS[index]-Vector2(0,direction*115.)
   var a:String="move_up" if direction<0 else "move_down"
   Input.action_press(a);await wait_seconds(1.5);Input.action_release(a)
   assert_eq(scene.model.state,"passed","fence %d direction %s"%[index,direction])
func test_menu_entry_does_not_cover_other_modes():
 GameState.brand_intro_played=true
 scene=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(scene);await wait_frames(2)
 var entry=scene._hero.get_node("MemoryEntry207")
 for extent in [Vector2(960,540),Vector2(1280,720),Vector2(1600,720)]:
  scene.size=extent;scene._layout()
  for name in ["RaceEntry190","DuelEntry193","JoustEntry196"]:
   assert_false(entry.get_global_rect().intersects(scene._hero.get_node(name).get_global_rect()))
  assert_false(entry.get_global_rect().intersects(scene.quit_button.get_global_rect()))
