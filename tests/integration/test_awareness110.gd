extends GutTest
var world:Node2D
func before_each():
 SaveData.world_generator_version=3;SaveData.horse_collection.seed_trial();SaveData.world_seed=752026;SaveData.world_position=WorldNominal98.home();SaveData.world_tamed=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_edits=[]
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false);world.player.position=Vector2(10000,10000);world.player.velocity=Vector2.ZERO
 for item in world._herd_horses.values():item.free()
 world._herd_horses.clear();world._occluders.clear();world._cover_dirty110=true
func after_each():world.free()
func plant(index:int,offset:Vector2):
 var horse=world.WildHorseScript.new();horse.setup({"pos":world.player.position+offset,"member_id":"awareness110#"+str(index),"member_index":index,"traits":{"coat":0,"mane":0,"pattern":0},"temperament":.2,"stats":{"speed":260}});horse.set_meta("c",Vector2i(99,99));world.add_child(horse);horse.set_physics_process(false);horse.road_provider94=func(_p,_r):return false
 world._herd_horses[horse.herd.member_id]=horse;horse.player_ref=world.player
 return horse
func test_alert_pause_and_slow_capture_still_possible():
 var horse=plant(0,Vector2(150,0));world.player.velocity=Vector2.RIGHT*70
 for i in 60:world._tick_taming(.016);horse._physics_process(.016)
 assert_true(horse.state.alert110);assert_eq(horse.state.spook,0.);assert_lt(horse.position.distance_to(horse.home),1.)
 assert_eq(world.player.lasso.resolve_capture(horse.global_position),horse);assert_true(horse.roped)
func test_group_flees_on_actual_throw_while_aimed_target_is_not_automatically_lost():
 var target=plant(0,Vector2(180,0));var friends:Array=[]
 for i in range(1,4):friends.append(plant(i,Vector2(180+i*50,70+i*25)))
 var ids:Array=[]
 for horse in friends:ids.append(horse.herd.member_id)
 world.player.lasso.throw_guard=func():return true
 world.player.lasso._charge_distance=180.;world.player.lasso.aim_direction=Vector2.RIGHT;world.player.lasso._release_throw()
 await get_tree().process_frame;await get_tree().process_frame
 for horse in friends:assert_gt(float(horse.get_meta("panic_left",0.)),0.)
 assert_eq(float(target.get_meta("panic_left",0.)),0.,"aimed target excluded during flight")
 await get_tree().create_timer(.4).timeout;assert_true(target.roped,"slow accurate throw remains valid")
 for tick in 260:
  world._tick_taming(.016)
  for horse in friends:horse._physics_process(.016)
 var half:Vector2=world.get_viewport_rect().size*.5
 for i in friends.size():
  var delta:Vector2=(friends[i].position-world.player.position).abs()
  assert_true(delta.x>half.x+40 or delta.y>half.y+40,"companion leaves viewport")
  assert_eq(friends[i].herd.member_id,ids[i])
func test_fast_runner_can_be_intercepted_with_prediction_not_random_veto():
 var horse=plant(0,Vector2(180,0));world.player.velocity=Vector2.RIGHT*260
 for tick in 40:world._tick_taming(.016);horse._physics_process(.016)
 assert_gt(horse.state.spook,0.)
 assert_eq(world.player.lasso.resolve_capture(horse.global_position),horse,"interception at landing remains possible")

func test_controlled_100_throws_slow_fast_and_predicted():
 var horse=plant(0,Vector2(180,0));var slow:int=0;var fast:int=0;var predicted:int=0;var rng=RandomNumberGenerator.new();rng.seed=110
 for mode in 3:
  for attempt in 100:
   horse.roped=false;horse.state=WorldTaming.new_state();horse.position=horse.home;horse.set_meta("panic_left",0.);horse.set_meta("escape_left110",0.);world._end_lasso()
   var heading:float=TAU*attempt/100.;world.player.velocity=Vector2.ZERO if mode==0 else Vector2.from_angle(heading)*260.
   if mode>0:
    for tick in 30:world._tick_taming(.016)
   var initial:Vector2=horse.position;var error_:Vector2=Vector2(rng.randf_range(-20,20),rng.randf_range(-20,20))
   var landing:Vector2=initial+world.player.velocity*.35+error_
   for tick in 22:world._tick_taming(.35/22.);horse._physics_process(.35/22.)
   if mode==2:landing=horse.position+error_
   if world.player.lasso.resolve_capture(landing)==horse:
    if mode==0:slow+=1
    elif mode==1:fast+=1
    else:predicted+=1
 print("BALANCE110 slow=",slow,"/100 fast_unled_mixed_headings=",fast,"/100 fast_perfect_prediction=",predicted,"/100")
 assert_gte(slow,90);assert_gt(fast,0);assert_lt(fast,slow);assert_gte(predicted,90)

func test_giant_tree_cover_uses_same_bounds_and_marker_clears_canopy():
 var pos=world.player.position
 var cover=world.DecorScript.occluder_box("tree",pos+Vector2(0,30),3.)
 world.register_occluder("giant121",cover)
 world._tick_rider_marker()
 assert_true(world._marker.visible)
 assert_lt(world._marker.position.y,cover.position.y)
 var horse=plant(0,Vector2(150,0));world.player.velocity=Vector2.RIGHT*70
 for i in 60:world._tick_taming(.016)
 assert_false(horse.state.alert110)
 world.player.position=cover.end+Vector2(80,80);world._tick_rider_marker()
 assert_false(world._marker.visible)
