extends GutTest
var level:Node
var old_intro:bool
var old_trial:bool
func before_each():
 old_intro=SaveData.dual_lasso_intro_shown;old_trial=SaveData.trial_session_active
 SaveData.dual_lasso_intro_shown=true;SaveData.trial_session_active=true;GameState.selected_level=5
 level=load('res://src/Presentation/level_0.tscn').instantiate();add_child(level)
 await wait_physics_frames(2)
 level.set_process(false);level.player.set_physics_process(false)
 for bull in level._active_bulls:bull.set_physics_process(false)
func after_each():
 level.free();SaveData.dual_lasso_intro_shown=old_intro;SaveData.trial_session_active=old_trial
func contact(at:Vector2)->void:
 var bull=level._active_bulls[0];level.player.global_position=at;level.player._stun_time_remaining=0.
 bull.global_position=at+Vector2(43,0);bull._touching_player=false;bull._touch_grace_remaining=0.;bull._check_player_contact()
func test_rider_inside_ranch_cannot_be_caught_across_fence():
 var bull=level._active_bulls[0];var held=level._active_bulls[1]
 assert_true(held.try_capture(held.global_position));assert_true(held.controller.is_held())
 bull.set_is_chaser(true)
 contact(level.pen.global_position+Vector2(35,0))
 assert_eq(level.player._stun_time_remaining,0.,'inside: rider is not stunned through fence')
 assert_true(held.controller.is_held(),'inside: rope is not lost')
 assert_false(bull._touching_player,'safe contact cannot latch a future outside hit')
 level.player.global_position=level.pen.global_position+Vector2(41,0);bull.global_position=level.player.global_position+Vector2(43,0)
 bull._check_player_contact()
 assert_gt(level.player._stun_time_remaining,0.,'leaving sanctuary restores contact immediately')
 assert_false(held.controller.is_held(),'outside: existing drop rule retained')
func test_every_edge_inside_and_outside_and_no_map_wide_immunity():
 var c:Vector2=level.pen.global_position
 for offset in [Vector2.ZERO,Vector2(40,0),Vector2(-40,0),Vector2(0,40),Vector2(0,-40),Vector2(40,40)]:
  contact(c+offset);assert_eq(level.player._stun_time_remaining,0.,'safe '+str(offset))
 for offset in [Vector2(40.1,0),Vector2(-40.1,0),Vector2(0,40.1),Vector2(0,-40.1),Vector2(0,150)]:
  contact(c+offset);assert_gt(level.player._stun_time_remaining,0.,'outside '+str(offset))
func test_unconfigured_bull_does_not_grant_default_origin_immunity():
 level._active_bulls[0].pen_rect=Rect2();contact(Vector2.ZERO)
 assert_gt(level.player._stun_time_remaining,0.)
func test_chaser_retreats_and_never_enters_margin_while_rider_is_home():
 var bull=level._active_bulls[0];var center:Vector2=level.pen.global_position
 level.player.global_position=center;bull.global_position=center+Vector2(150,0);bull.set_is_chaser(true)
 var before:float=bull.global_position.distance_to(center)
 for i in 100:bull._physics_process(1./60.)
 assert_gt(bull.global_position.distance_to(center),before)
 assert_false(bull.pen_rect.grow(bull.RANCH_MARGIN305).has_point(bull.global_position))
 assert_eq(bull._chase_heading,Vector2.ZERO);assert_eq(level.player._stun_time_remaining,0.)
func test_already_near_bull_moves_away_when_rider_enters():
 var bull=level._active_bulls[0];var c:Vector2=level.pen.global_position
 level.player.global_position=c;bull.global_position=c+Vector2(80,0);bull.set_is_chaser(true)
 for i in 60:bull._physics_process(1./60.)
 assert_gt(bull.global_position.distance_to(c),140.)
 assert_false(bull.pen_rect.grow(bull.RANCH_MARGIN305).has_point(bull.global_position))
