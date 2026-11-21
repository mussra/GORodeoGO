extends GutTest
var mode:bool
func before_each():mode=GameState.bullet_button327;GameState.bullet_button327=true
func after_each():
 GameState.bullet_button327=mode;Engine.time_scale=1.
 for key in ['move_left','move_right','move_up','move_down']:Input.action_release(key)
func controller327()->DodgeController:
 var body:=CharacterBody2D.new();add_child_autofree(body)
 var d:=DodgeController.new();body.add_child(d);d.owner_body=body;return d
func test_left_right_and_diagonal_begin_and_continue_without_new_drag():
 for heading in [Vector2.LEFT,Vector2.RIGHT,Vector2(-1,-1).normalized(),Vector2(1,1).normalized()]:
  var d=controller327();d.move_held326=true
  assert_true(d.begin_drawing326(heading));assert_eq(d.draw_points.size(),2)
  assert_almost_eq(d.draw_points[-1],heading*18.,Vector2.ONE*.01)
  d.process_drawing(.05)
  assert_almost_eq(d.draw_virtual,heading*33.,Vector2.ONE*.01)
  d.on_move_released(heading);assert_false(d.path.is_empty());d.cancel()
func test_actual_left_action_seeds_trace_and_drag_takes_over():
 var d=controller327();Input.action_press('move_left');d.move_held326=true;d.move_index326=0
 assert_true(d.begin_drawing326());assert_lt(d.draw_virtual.x,0.)
 var drag:=InputEventScreenDrag.new();drag.index=0;drag.position=Vector2(0,-40)
 d.handle_input(drag);assert_eq(d.automatic_heading327,Vector2.ZERO)
 var point=d.draw_virtual;d.process_drawing(.05)
 assert_eq(d.draw_virtual,point,'No automatic continuation after manual change away from edge')
 d.cancel()
func test_button_mode_never_activates_on_double_press():
 var d=controller327();d.on_move_pressed();d.on_move_released(Vector2.ZERO);d.on_move_pressed()
 assert_false(d.drawing)
func test_optional_double_tap_and_running_repress():
 GameState.bullet_button327=false
 var d=controller327();d.on_move_pressed();d.on_move_released(Vector2.ZERO);d.on_move_pressed()
 assert_true(d.drawing);d.cancel()
 d.moving_with_input=func()->bool:return true
 d.on_move_pressed();d.move_pressed_at-=1.;d.on_move_released(Vector2.LEFT);d.on_move_pressed()
 assert_true(d.drawing);assert_eq(d.automatic_heading327,Vector2.LEFT);d.cancel()
func test_setting_roundtrip_preserves_other_control_and_unrelated_keys():
 var cfg=ConfigFile.new();cfg.load(GameState.CONTROL_PREF258)
 var backup=cfg.encode_to_text();var anchor=GameState.anchored_movement258
 assert_true(GameState.set_bullet_button327(false));assert_true(GameState.set_movement258(not anchor))
 GameState.load_movement258();assert_false(GameState.bullet_button327);assert_eq(GameState.anchored_movement258,not anchor)
 assert_true(GameState.set_bullet_button327(true));GameState.load_movement258();assert_true(GameState.bullet_button327);assert_eq(GameState.anchored_movement258,not anchor)
 cfg.parse(backup);cfg.save(GameState.CONTROL_PREF258);GameState.load_movement258()
func test_approved_atlas_slices_both_icons_and_preserves_button_footprint():
 for cell in [0,1]:
  var texture=ActionIcons327.texture327(cell);assert_not_null(texture);assert_eq(texture.get_size(),Vector2(512,512))
  var b=Button.new();b.size=Vector2(112,112);add_child_autofree(b);ActionIcons327.attach327(b,cell)
  var art=b.get_node('ActionArt327');assert_eq(art.size,Vector2(88,76));assert_eq(b.size,Vector2(112,112));assert_eq(art.mouse_filter,Control.MOUSE_FILTER_IGNORE)
