extends GutTest
func make_rider():
 SaveData.horse_collection.seed_trial()
 var p=load("res://src/Presentation/world_player.gd").new();add_child_autofree(p);p.set_physics_process(false);return p
func test_world_hand_tracks_scaled_raised_sprite_and_facing():
 var p=make_rider();var s=p._sprite_swap._sprite
 assert_eq(p.scale,Vector2.ONE,"physics host stays unscaled")
 assert_almost_eq((44+s.offset.y)*s.scale.y,0.,.001,"hooves remain at physics origin")
 assert_almost_eq(p.effect_hand_local().y,-67.2,.01)
 assert_almost_eq(p.effect_hand_local().x,9.6,.01)
 s.flip_h=true;assert_almost_eq(p.effect_hand_local().x,-9.6,.01)
 s.position.y=-25;assert_almost_eq(p.effect_hand_local().y,-92.2,.01)
func test_charge_start_moves_to_hand_but_ground_target_does_not_move():
 var p=make_rider();p.position=Vector2(300,200)
 p.lasso._start_charging();p.lasso._charge_distance=180;p.lasso.aim_direction=Vector2.RIGHT;p.velocity=Vector2(20,10);p.lasso._update_charge_visual()
 var line=p.lasso._charge_visual
 assert_eq(line.points[0],p.effect_hand_local())
 var expected=LassoController.inherited_landing(Vector2.ZERO,Vector2.RIGHT,180,p.velocity,p.lasso.lasso_travel_time)
 assert_eq(line.points[1],expected,"landing retains original ground range and velocity")
 assert_eq(p.lasso.flight_origin_global(),p.to_global(p.effect_hand_local()))
 p.lasso._animate_lasso_flight(p.lasso.flight_origin_global(),p.global_position+expected)
 assert_eq(p.lasso._flight_line.origin_provider.call(),p.lasso.flight_origin_global())
 p.position+=Vector2(40,20)
 assert_eq(p.lasso._flight_line.origin_provider.call(),p.lasso.flight_origin_global(),"rope follows rider hand")
 p.lasso.cancel_all_actions()
func test_default_shared_lasso_preserves_levels_anchors():
 var host=Node2D.new();add_child_autofree(host);host.position=Vector2(30,40)
 var lasso=LassoController.new();host.add_child(lasso)
 assert_eq(lasso.charge_origin_local(),Vector2.ZERO)
 assert_eq(lasso.flight_origin_global(),Vector2(38,28))
