extends GutTest
var player:Node2D
var fence:Node2D
func before_each()->void:
 var scene:Node=load("res://src/Presentation/level_0.tscn").instantiate();player=scene.get_node("Player").duplicate();scene.free();add_child_autofree(player);player.position=Vector2(-90,0);player.world_bounds=Rect2(-400,-250,800,500);player.can_jump=true;player.collision_mask|=32
 fence=JumpFence.new();fence.position=Vector2.ZERO;fence.fence_size=Vector2(14,150);add_child_autofree(fence);await get_tree().physics_frame
func test_only_capable_horse_and_clear_landing_allowed()->void:
 player.can_jump=false;assert_false(player.request_jump(Vector2.RIGHT));player.can_jump=true;assert_true(player.request_jump(Vector2.RIGHT));assert_eq(player.collision_mask&32,0)
 for i in range(50):await get_tree().physics_frame
 assert_gt(player.position.x,50);assert_eq(player.collision_mask&32,32);assert_eq(player._jump_time,0.0)
func test_bounds_and_nonjumpable_obstacle_reject_before_launch()->void:
 player.world_bounds=Rect2(-120,-100,200,200);assert_false(player.request_jump(Vector2.RIGHT));player.world_bounds=Rect2(-400,-250,800,500)
 var rock:=StaticBody2D.new();rock.collision_layer=4;var shape:=CollisionShape2D.new();var box:=RectangleShape2D.new();box.size=Vector2(30,100);shape.shape=box;rock.add_child(shape);rock.position=Vector2(30,0);add_child_autofree(rock);await get_tree().physics_frame
 assert_false(player.request_jump(Vector2.RIGHT));assert_eq(player.position,Vector2(-90,0));assert_eq(player.collision_mask&32,32)
func test_fence_stays_solid_for_bull_and_landing_rechecks_dynamic_obstacle()->void:
 var scene:Node=load("res://src/Presentation/level_0.tscn").instantiate();var bull:Node2D=scene.get_node("Bull").duplicate();scene.free();bull.position=Vector2(-60,30);add_child_autofree(bull);bull.set_physics_process(false);bull._update_collision(BullState.State.CONTROLLED);assert_eq(bull.collision_mask&32,32)
 assert_true(player.request_jump(Vector2.RIGHT))
 var rock:=StaticBody2D.new();rock.collision_layer=4;var shape:=CollisionShape2D.new();var box:=RectangleShape2D.new();box.size=Vector2(50,100);shape.shape=box;rock.add_child(shape);rock.position=Vector2(85,0);add_child_autofree(rock)
 for i in range(50):await get_tree().physics_frame
 assert_eq(player.collision_mask&32,32);assert_lt(player.position.x,65)

func test_stun_cancels_jump_and_restores_collision_and_sprite()->void:
 assert_true(player.request_jump(Vector2.RIGHT));player._process_jump(.2);player.stun(.5)
 assert_eq(player._jump_time,0.0);assert_eq(player.collision_mask&32,32);assert_eq(player.position,Vector2(-90,0));assert_eq(player._sprite_swap._sprite.scale,Vector2.ONE)
func test_dodge_and_lasso_cannot_start_in_midair()->void:
 player.dodge_available=true;assert_true(player.request_jump(Vector2.RIGHT));assert_false(player.request_dodge(Vector2.RIGHT));assert_false(player.request_dodge_path(PackedVector2Array([Vector2.ZERO,Vector2(80,0)])))
 player.lasso._on_aim_pressed();assert_false(player.lasso._touch_aim_active)

func test_roped_bull_recovers_path_around_both_ends_of_solid_fence()->void:
 var scene:Node=load("res://src/Presentation/level_0.tscn").instantiate();var bull:Node=scene.get_node("Bull").duplicate();scene.free();bull.position=Vector2(-85,0);bull.world_bounds=Rect2(-400,-250,800,500);add_child_autofree(bull);bull.set_physics_process(false);bull._update_collision(BullState.State.CONTROLLED);await get_tree().physics_frame
 bull._tow_path.assign([Vector2(85,0)]);bull._recover_tow_route();assert_gt(bull._tow_path.size(),1)
 var previous:Vector2=bull.global_position
 for point:Vector2 in bull._tow_path:
  assert_false(bull.test_move(Transform2D(0,previous),point-previous),"each route segment remains solid-collision safe");previous=point

func test_overhead_bar_follows_jump_and_restores_on_land_and_cancel()->void:
 player.set_physics_process(false);assert_eq(player._overhead_bar_anchor(),Vector2(0,-59));assert_true(player.request_jump(Vector2.RIGHT));player._process_jump(HorseJump.DURATION/2)
 assert_almost_eq(player._overhead_bar_anchor().y,-59-HorseJump.arc(.5),.01);assert_lt(player._overhead_bar_anchor().y,-90.0)
 player._process_jump(HorseJump.DURATION/2);assert_eq(player._overhead_bar_anchor(),Vector2(0,-59));player._jump_cooldown=0;assert_true(player.request_jump(Vector2.LEFT));player._process_jump(.1);player.stun(.2);assert_eq(player._overhead_bar_anchor(),Vector2(0,-59))
func test_dodge_trail_expires_during_jump_and_stun()->void:
 player.set_physics_process(false);player._skid_trail.assign([Vector2(-120,0),Vector2(-90,0)]);player._trail_fade=.3;assert_true(player.request_jump(Vector2.RIGHT))
 player._physics_process(.15);assert_almost_eq(player._trail_fade,.15,.001);player._physics_process(.2);assert_eq(player._trail_fade,0.0);assert_true(player._skid_trail.is_empty())
 player.stun(.5);player._skid_trail.assign([Vector2(-120,0),Vector2(-90,0)]);player._trail_fade=.1;player._physics_process(.2);assert_eq(player._trail_fade,0.0);assert_true(player._skid_trail.is_empty())
