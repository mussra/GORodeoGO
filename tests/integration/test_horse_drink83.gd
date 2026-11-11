extends GutTest
func _actor(world:Node2D,corral:bool=false):
 var a
 if corral:
  var scene=load("res://src/Presentation/level_0.tscn").instantiate();a=scene.get_node("Player").duplicate();scene.free()
 else:a=load("res://src/Presentation/world_player.gd").new()
 world.add_child(a);a.set_physics_process(false);return a
func before_each():SaveData.horse_collection.seed_trial()
func test_same_component_idle_near_water_cancel_move_and_no_save_change():
 var w=Node2D.new();add_child_autofree(w);HorseWater.add(w,Rect2(45,-40,90,80),"pond")
 var a=_actor(w);var before=SaveData.horse_collection.find(SaveData.horse_collection.selected).duplicate(true)
 assert_false(a.drink.step(.3,Vector2.ZERO));assert_false(a.drink.active)
 assert_true(a.drink.step(.31,Vector2.ZERO));assert_true(a.drink.active);assert_false(a._sprite_swap._sprite.visible)
 assert_true(a.drink.step(.6,Vector2.ZERO));assert_eq(a.drink.visual.texture,HorseDrink.texture(1,before.traits,SaveData.hat_color))
 assert_eq(a.position,Vector2.ZERO);assert_eq(SaveData.horse_collection.find(SaveData.horse_collection.selected),before)
 assert_false(a.drink.step(.1,Vector2.RIGHT));assert_true(a._sprite_swap._sprite.visible);assert_false(a.drink.visual.visible)
func test_far_hay_moving_stun_jump_and_lasso_never_drink():
 var w=Node2D.new();add_child_autofree(w);var a=_actor(w)
 assert_false(a.drink.step(1,Vector2.ZERO))
 var station=DistractionStation.new();station.kind="hay";w.add_child(station);assert_false(a.drink.step(1,Vector2.ZERO))
 HorseWater.add(w,Rect2(45,-40,90,80),"river")
 for condition in ["speed","stun","jump","lasso"]:
  a.velocity=Vector2(20,0) if condition=="speed" else Vector2.ZERO
  a._stun_time_remaining=1 if condition=="stun" else 0;a._jump_time=1 if condition=="jump" else 0
  if condition=="lasso":
   a.set_physics_process(true);a.lasso._on_aim_pressed();a.set_physics_process(false)
  assert_false(a.drink.step(1,Vector2.ZERO),condition)
 a._jump_time=0;a._stun_time_remaining=0;a.lasso.cancel_all_actions();a.velocity=Vector2.ZERO
 assert_true(a.drink.step(1,Vector2.ZERO));a.stun(1);assert_false(a.drink.step(.01,Vector2.ZERO))
func test_water_is_solid_not_jumpable_shared_in_corral():
 var w=Node2D.new();add_child_autofree(w);HorseWater.add(w,Rect2(45,-40,200,80),"river")
 var a=_actor(w,true);a.can_jump=true
 await wait_physics_frames(2)
 assert_eq(a.collision_mask&64,64);assert_true(a.test_move(a.global_transform,Vector2(80,0)));assert_false(a.request_jump(Vector2.RIGHT))
 assert_true(a.drink.step(1,Vector2.ZERO));assert_true(a.drink is HorseDrink)
 a.cancel_input();assert_false(a.drink.active)
func test_left_bank_flip_and_cleared_source():
 var w=Node2D.new();add_child_autofree(w);var water=HorseWater.add(w,Rect2(-135,-40,90,80),"trough");var a=_actor(w)
 assert_true(a.drink.step(1,Vector2.ZERO));assert_true(a.drink.visual.flip_h)
 water.free();assert_false(a.drink.step(.1,Vector2.ZERO));assert_true(a._sprite_swap._sprite.visible)
func test_hat_and_mask_cache_preserves_originals():
 var t={"coat":3,"mane":2,"pattern":0,"eyes":4,"finish":"normal"}
 for p in 2:
  var original=load(HorseDrink.BASE+"pose_%d.png"%p).get_image();var unchanged=original.get_data()
  var blue=HorseDrink.texture(p,t,"blue");assert_same(blue,HorseDrink.texture(p,t,"blue"))
  var sand=HorseDrink.texture(p,t,"sand");assert_ne(blue.get_image().get_data(),sand.get_image().get_data());assert_eq(original.get_data(),unchanged)
