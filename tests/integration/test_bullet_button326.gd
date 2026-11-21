extends GutTest
var world:Node
func after_each():
 if is_instance_valid(world):world.free()
 Engine.time_scale=1.;get_tree().paused=false
 for a in ['move_left','move_right','move_up','move_down','aim_left','aim_right','aim_up','aim_down']:Input.action_release(a)
 await wait_process_frames(2)
func make326():
 ignore326(get_tree().root.get_node('GutRunner'))
 SaveData.save_path='user://bullet326-only.cfg';SaveData.world_generator_version=3;SaveData.world_seed=752026;SaveData.world_position=WorldNominal98.home();SaveData.world_edits=[];SaveData.world_quests={};SaveData.world_jobs249={};SaveData.world_goat_captures=[];SaveData.world_pig_captures=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();GameState.controls_world323=false
 world=load('res://src/Presentation/frontier_world.gd').new();add_child(world)
 while world._loading_world:await wait_process_frames(1)
 var cover=get_tree().root.get_node_or_null('FrontierTransition')
 if cover!=null:
  for i in 100:
   if not is_instance_valid(cover):break
   await wait_process_frames(1)
 world.set_process(false);world.set_physics_process(false)
 await wait_process_frames(4)
 world.player.dodge.available=true
func test_linked_pig_and_goat_keep_rope_position_and_timer_during_bullet_time():
 await make326()
 for goat in [false,true]:
  var animal=world._prototype_goats.get_child(0) if goat else world._lasso_pigs()[0]
  world.player.position=animal.position-Vector2(150,0)
  world._on_lasso_prey_captured(animal)
  assert_true(animal.roped)
  var held:float=animal.held;var start:Vector2=animal.position;var state=animal.state.duplicate(true)
  assert_true(world.player.dodge.begin_drawing326())
  for i in 120:
   if goat:world._tick_goats(.01)
   else:world._tick_pigs(.01)
   world._tick_lasso(.01)
  assert_true(animal.roped);assert_same(world._lasso_horse,animal)
  assert_eq(animal.position,start);assert_eq(animal.state,state)
  await wait_process_frames(3)
  assert_eq(animal.held,held,'Hold expiry pauses with linked animal')
  # Even a contact/range threshold cannot end the rope during trace choice.
  animal.position=world.player.position
  if goat:world._tick_goats(.01)
  else:world._tick_pigs(.01)
  assert_true(animal.roped);assert_eq(world.player._stun_time_remaining,0.)
  animal.position=world.player.position+Vector2(300,0)
  if goat:world._tick_goats(.01)
  else:world._tick_pigs(.01)
  assert_true(animal.roped)
  world.player.dodge.cancel()
  if goat:world._tick_goats(.01)
  else:world._tick_pigs(.01)
  assert_false(animal.roped,'Normal range-break rule resumes outside bullet-time')
func ignore326(node:Node):
 if node is Control:node.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for child in node.get_children():ignore326(child)
func tap326(point:Vector2,index_:int=2):
 for down in [true,false]:
  var e=InputEventScreenTouch.new();e.index=index_;e.position=get_viewport().get_final_transform()*point;e.pressed=down;Input.parse_input_event(e);Input.flush_buffered_events()
func test_native_button_not_double_tap_starts_drawing_and_never_releases_lasso():
 await make326()
 # Restore real HUD button after hiding the test-runner UI.
 var button=world.get_node('DodgeActions326/DodgeButton326');button.mouse_filter=Control.MOUSE_FILTER_STOP
 await wait_process_frames(2)
 var animal=world._lasso_pigs()[0];world.player.position=animal.position-Vector2(150,0);world._on_lasso_prey_captured(animal)
 watch_signals(world.player.lasso)
 tap326(Vector2(140,440));await wait_process_frames(3)
 tap326(Vector2(140,440));await wait_process_frames(3)
 assert_false(world.player.dodge.drawing);assert_eq(Engine.time_scale,1.)
 tap326(button.get_global_rect().get_center());await wait_process_frames(2)
 assert_true(world.player.dodge.drawing);assert_eq(Engine.time_scale,DodgeController.DRAW_TIME_SCALE)
 assert_true(animal.roped);assert_same(world._lasso_horse,animal)
 assert_signal_not_emitted(world.player.lasso,'release_requested')
 # Button finger cannot own the next movement trace.
 var e=InputEventScreenTouch.new();e.index=0;e.position=get_viewport().get_final_transform()*Vector2(150,440);e.pressed=true;Input.parse_input_event(e);Input.flush_buffered_events()
 await wait_process_frames(2)
 print('BIND326 held=',world.player.dodge.move_held326,' index=',world.player.dodge._draw_touch_index,' points=',world.player.dodge.draw_points,' time=',world.player.dodge._now_seconds()-world.player.dodge.drawing_real_started)
 var drag=InputEventScreenDrag.new();drag.index=0;drag.position=get_viewport().get_final_transform()*Vector2(220,440);Input.parse_input_event(drag);Input.flush_buffered_events()
 await wait_process_frames(2)
 print('DRAW326 held=',world.player.dodge.move_held326,' index=',world.player.dodge._draw_touch_index,' points=',world.player.dodge.draw_points,' time=',world.player.dodge._now_seconds()-world.player.dodge.drawing_real_started)
 assert_gt(world.player.dodge.draw_points.size(),1)
 var release=InputEventScreenTouch.new();release.index=0;release.position=drag.position;release.pressed=false;Input.parse_input_event(release);Input.flush_buffered_events()
 await wait_process_frames(2)
 assert_false(world.player.dodge.drawing);assert_eq(Engine.time_scale,1.)
 assert_false(world.player.dodge.path.is_empty())

func test_corral_uses_the_same_native_button_and_preserves_held_bull():
 ignore326(get_tree().root.get_node('GutRunner'))
 SaveData.debug_mode=true;SaveData.dual_lasso_intro_shown=true;GameState.selected_level=1
 world=load('res://src/Presentation/level_0.tscn').instantiate();add_child(world)
 await wait_physics_frames(4)
 world.player.dodge_available=true
 var button=world.get_node('DodgeActions326/DodgeButton326')
 await wait_process_frames(2)
 var bull=world._active_bulls[0]
 assert_same(world.player.lasso.resolve_capture(bull.global_position),bull)
 watch_signals(world.player)
 tap326(button.get_global_rect().get_center());await wait_process_frames(2)
 assert_true(world.player.dodge.drawing);assert_true(bull.controller.is_held())
 assert_signal_not_emitted(world.player,'release_requested')
 world.player.cancel_input();assert_eq(Engine.time_scale,1.)
func test_button_layout_separates_whip_and_cooldown_rules():
 for extent in [Vector2(960,540),Vector2(1280,720),Vector2(1600,720),Vector2(1280,960)]:
  var pos=DodgeButton326.placement326(extent)
  assert_true(Rect2(Vector2.ZERO,extent).encloses(Rect2(pos,Vector2(112,112))))
  assert_false(Rect2(pos,Vector2(112,112)).intersects(Rect2(ScareButton265.placement301(extent),Vector2(112,112))))
 var host=CharacterBody2D.new();add_child_autofree(host)
 var dodge=DodgeController.new();dodge.owner_body=host;host.add_child(dodge)
 dodge.available=false;assert_false(dodge.begin_drawing326())
 dodge.available=true;dodge.cooldown=1.;assert_false(dodge.begin_drawing326())
 dodge.cooldown=0.;dodge.can_start=func()->bool:return false
 assert_false(dodge.begin_drawing326())
 dodge.can_start=func()->bool:return true
 assert_true(dodge.begin_drawing326());assert_false(dodge.begin_drawing326())
 dodge.cancel();assert_eq(Engine.time_scale,1.)
