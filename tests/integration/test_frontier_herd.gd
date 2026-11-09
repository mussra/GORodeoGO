extends GutTest
func world()->Node2D:
 SaveData.world_seed=424242;SaveData.world_tamed.clear();SaveData.world_discovered.clear();SaveData.world_missions.clear();SaveData.world_position=Vector2(0,160);SaveData.horse_collection.seed_trial()
 var w:Node2D=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child_autofree(w);w.set_process(false);w.set_physics_process(false);return w
func plant(w:Node2D,c:Vector2i,members_:Array)->Array:
 var out:Array=[]
 for member in members_:
  if SaveData.world_tamed.has(member.member_id):continue
  var horse:Node2D=w.WildHorseScript.new();horse.setup(member);horse.set_meta("c",c);w.add_child(horse);w._herd_horses[member.member_id]=horse;out.append(horse)
 return out
func test_running_alerts_group_while_slow_approach_does_not()->void:
 var w:Node2D=world();await wait_process_frames(3)
 var base:Dictionary={"pos":Vector2(140,160),"traits":{"coat":0,"mane":0,"pattern":0,"eyes":0,"finish":"normal"},"temperament":.1,"stats":{"speed":260}}
 var horses:Array=plant(w,Vector2i(99,99),WorldHerd.members(base,1,99,99))
 w.player.position=horses[0].position+Vector2(-50,0);w.player.velocity=Vector2(200,0);w._tick_taming(.016)
 for horse in horses:assert_gt(float(horse.state.spook),0.0,"nearby running alerts herd members")
 for horse in horses:horse.state=WorldTaming.new_state()
 w.player.velocity=Vector2(80,0);w._tick_taming(.016)
 for horse in horses:assert_eq(float(horse.state.spook),0.0,"slow approach stays calm")
func test_individual_capture_persists_and_old_complete_herds_stay_complete()->void:
 var w:Node2D=world();await wait_process_frames(3)
 var c:=Vector2i.ZERO;var base:Dictionary={}
 for x in range(1,10):
  base=WorldMap.generate(424242,x,1).herd
  if not base.is_empty():c=Vector2i(x,1);break
 assert_false(base.is_empty())
 var members_:Array=WorldHerd.members(base,424242,c.x,c.y);var horses:Array=plant(w,c,members_)
 var before:int=SaveData.horse_collection.horses.size()
 w._deliver_horse(c,horses[0]);await wait_process_frames(2)
 assert_true(SaveData.world_tamed.has(members_[0].member_id))
 assert_false(SaveData.world_tamed.has(WorldMap.herd_mission_id(c.x,c.y)))
 assert_eq(SaveData.horse_collection.horses.size(),before+1)
 var remaining:int=0
 for member in WorldHerd.members(base,424242,c.x,c.y):
  if not SaveData.world_tamed.has(member.member_id):remaining+=1
 assert_eq(remaining,members_.size()-1,"reload excludes only captured individual")
 for i in range(1,horses.size()):w._deliver_horse(c,horses[i])
 assert_true(SaveData.world_tamed.has(WorldMap.herd_mission_id(c.x,c.y)))
 var ids:Array=[]
 for horse in SaveData.horse_collection.horses:assert_false(ids.has(horse.id));ids.append(horse.id)
func test_guide_is_stable_and_replaced_when_roped_or_captured()->void:
 var w:Node2D=world();await wait_process_frames(3)
 var base:Dictionary={"pos":Vector2(140,160),"traits":{"coat":0,"mane":0,"pattern":0,"eyes":0,"finish":"normal"},"temperament":.1,"stats":{"speed":260}}
 var horses:Array=plant(w,Vector2i(99,99),WorldHerd.members(base,1,99,99))
 var plans:Dictionary=w._herd_guides()
 for horse in horses:assert_eq(plans[horse].guide,horses[0])
 horses[0].roped=true
 plans=w._herd_guides();assert_false(plans.has(horses[0]))
 for i in range(1,horses.size()):assert_eq(plans[horses[i]].guide,horses[1])
 horses[1].state.progress=1.0
 plans=w._herd_guides();assert_false(plans.has(horses[1]));assert_eq(plans[horses[2]].guide,horses[2])
func test_fleeing_group_stays_within_cohesion_radius()->void:
 var w:Node2D=world();await wait_process_frames(3)
 var base:Dictionary={"pos":Vector2(140,160),"traits":{"coat":0,"mane":0,"pattern":0,"eyes":0,"finish":"normal"},"temperament":.1,"stats":{"speed":260}}
 var horses:Array=plant(w,Vector2i(99,99),WorldHerd.members(base,1,99,99))
 for horse in horses:horse.set_physics_process(false)
 var worst:float=0.0
 for tick in range(480):
  w.player.position=horses[0].position+Vector2(-90,15);w.player.velocity=Vector2(200,0)
  w._tick_taming(1.0/60.0)
  for horse in horses:horse._physics_process(1.0/60.0)
  for horse in horses:worst=maxf(worst,horse.position.distance_to(horses[0].position))
 assert_lte(worst,WorldHerd.COHESION_RADIUS+7.0,"8 second chase stays within280px plus one physics step and rounding")
 var plans:Dictionary=w._herd_guides()
 var guide:Node2D=plans[horses[0]].guide
 horses[-1].position=guide.position+Vector2(-400,0)
 var before:float=horses[-1].position.distance_to(guide.position)
 for tick in range(60):
  w.player.position=guide.position+Vector2(-90,0);w.player.velocity=Vector2(200,0);w._tick_taming(1.0/60.0)
  for horse in horses:horse._physics_process(1.0/60.0)
 assert_lt(horses[-1].position.distance_to(guide.position),before,"straggler regroups without teleport")
func test_lasso_flight_holds_free_group_then_miss_panics()->void:
 var w:Node2D=world();await wait_process_frames(3)
 var base:Dictionary={"pos":Vector2(140,160),"traits":{"coat":0,"mane":0,"pattern":1,"eyes":0,"finish":"normal"},"temperament":.1,"stats":{"speed":260}}
 var horses:Array=plant(w,Vector2i(99,99),WorldHerd.members(base,1,99,99))
 w.player.position=horses[0].position+Vector2(-100,0);w.player.velocity=Vector2(260,0)
 var positions:Array=[]
 for horse in horses:
  positions.append(horse.position);horse.set_physics_process(false)
  horse.state.spook=2.0;horse.flee_velocity(Vector2(350,0),true)
 w.player.lasso.lasso_released.emit()
 for tick in 21:
  w._tick_taming(1.0/60)
  for i in horses.size():
   horses[i]._physics_process(1.0/60)
   assert_eq(horses[i].position,positions[i],"no dodge during flight")
   assert_eq(float(horses[i].get_meta("panic_left",0.0)),0.0)
 w.player.lasso.landing_resolved.emit(Vector2(-10000,0),null)
 w._tick_taming(.016)
 for horse in horses:
  assert_false(horse.flight_hold)
  assert_gt(float(horse.get_meta("panic_left",0.0)),1.0)
  assert_gt(horse._flee.length(),230.0)
 assert_eq(w.player.lasso.max_throw_distance,220.0)
 assert_eq(w.player.lasso.lasso_travel_time,.35)
 assert_eq(w.player.lasso.capture_area_visual_radius,58.0)
func test_successful_landing_does_not_panic_free_herd()->void:
 var w:Node2D=world();await wait_process_frames(3)
 var base:Dictionary={"pos":Vector2(140,160),"traits":{"coat":0,"mane":0,"pattern":1,"eyes":0,"finish":"normal"},"temperament":.1,"stats":{"speed":260}}
 var horses:Array=plant(w,Vector2i(99,99),WorldHerd.members(base,1,99,99))
 w.player.position=horses[0].position+Vector2(-100,0);w.player.velocity=Vector2.ZERO
 w.player.lasso.lasso_released.emit()
 var caught:Node2D=w.player.lasso.resolve_capture(horses[0].position)
 w.player.lasso.landing_resolved.emit(horses[0].position,caught)
 assert_eq(caught,horses[0]);assert_true(caught.roped)
 for horse in horses:
  assert_false(horse.flight_hold)
  assert_eq(float(horse.get_meta("panic_left",0.0)),0.0)
func test_panic_group_cohesion_and_capture_remain_working()->void:
 var w:Node2D=world();await wait_process_frames(3)
 var base:Dictionary={"pos":Vector2(140,160),"traits":{"coat":0,"mane":0,"pattern":1,"eyes":0,"finish":"normal"},"temperament":.1,"stats":{"speed":260}}
 var horses:Array=plant(w,Vector2i(99,99),WorldHerd.members(base,1,99,99))
 for horse in horses:horse.set_physics_process(false);horse.touch_grace=100.0
 w.player.position=horses[0].position+Vector2(-90,0);w.player.lasso.lasso_released.emit();w.player.lasso.landing_resolved.emit(Vector2(-10000,0),null)
 var worst:float=0.0
 for tick in range(480):
  w.player.position=horses[0].position+Vector2(-90,15);w.player.velocity=Vector2(260,0)
  w._tick_taming(1.0/60.0)
  for horse in horses:horse._physics_process(1.0/60.0)
  for horse in horses:worst=maxf(worst,horse.position.distance_to(horses[0].position))
 assert_lte(worst,WorldHerd.COHESION_RADIUS+7.0)
 assert_gt(float(horses[0].get_meta("chase_time",0.0)),6.0)
 var prey:Node2D=w.player.lasso.resolve_capture(horses[0].position)
 assert_eq(prey,horses[0]);assert_true(horses[0].roped)
 var origin:Vector2=horses[0].position;horses[0]._physics_process(.1);assert_eq(horses[0].position,origin)

func test_opening_navigation_during_flight_unfreezes_without_panic()->void:
 var w:Node2D=world();await wait_process_frames(3)
 var base:Dictionary={"pos":Vector2(140,160),"traits":{"coat":0,"mane":0,"pattern":1,"eyes":0,"finish":"normal"},"temperament":.1,"stats":{"speed":260}}
 var horses:Array=plant(w,Vector2i(99,99),WorldHerd.members(base,1,99,99))
 w.player.position=horses[0].position+Vector2(-100,0)
 w.player.lasso._release_throw(Vector2(1,0))
 assert_true(horses[0].flight_hold)
 w._open_navigation()
 for horse in horses:
  assert_false(horse.flight_hold,"cancel flight releases hold even while paused")
  assert_eq(float(horse.get_meta("panic_left",0.0)),0.0,"cancel does not count as a missed landing")
 w._close_navigation()
 await wait_seconds(.4)
 assert_false(w.player.lasso.is_in_flight())
