extends GutTest
func test_one_source_river_enters_roots_and_approach_upstream_return_are_walkable():
 for seed_ in [1,123,752026,999999]:
  var data:=CountryRoute146.plan(seed_)
  assert_eq(data,CountryRoute146.plan(seed_));assert_eq(data.river[0],data.source);assert_eq(data.river[-1],data.roots)
  assert_true(data.tree.has_point(data.roots));assert_gt(data.tree.size.x,1280.)
  assert_true(CountryRoute146.path_clear(data,data.approach));assert_true(CountryRoute146.path_clear(data,data.upstream))
  var reverse:PackedVector2Array=data.upstream.duplicate();reverse.reverse();assert_true(CountryRoute146.path_clear(data,reverse))
func test_water_and_tree_block_without_jumping_across_them():
 var data:=CountryRoute146.plan(123)
 assert_true(CountryRoute146.blocked(data,data.roots));assert_true(CountryRoute146.blocked(data,data.source));assert_false(CountryRoute146.blocked(data,data.entry))
 var origin:Vector2=data.bank[1];var goal:Vector2=data.river[1]-Vector2(300,0);var result:=CountryRoute146.safe_step(data,origin,goal)
 assert_false(CountryRoute146.blocked(data,result));assert_lt(result.distance_to(origin),origin.distance_to(goal))
func test_ledger_separates_maps_preserves_notes_and_uses_layered_home():
 for gen in [1,2,3]:
  var origin:=Vector2(-10000,470);var base:=CountryLedger146.fresh(123,gen)
  assert_true(CountryLedger146.valid(base,123,gen));assert_eq(CountryLedger146.home(base),{"map":"frontier","kind":"ranch"})
  var entered:=CountryLedger146.enter(base,origin,456);assert_false(entered.is_empty());assert_eq(base.maps,{})
  assert_true(CountryLedger146.valid(entered,123,gen));assert_eq(CountryLedger146.home(entered).map,CountryRoute146.ID)
  var data:=CountryRoute146.plan(456);entered.maps.water146.notes={"0,0":[{"note":"río"}]}
  entered=CountryLedger146.record_position(entered,data.sites.tree)
  assert_true(entered.maps.water146.visited.has("tree"));assert_false(entered.maps.water146.visited.has("source"))
  var returned:=CountryLedger146.leave(entered,data.entry);assert_eq(returned.arrival,origin);assert_eq(returned.state.active,"frontier")
  var again:=CountryLedger146.enter(returned.state,Vector2(999,470),789)
  assert_eq(again.maps.water146.seed,456);assert_eq(again.maps.water146.notes,entered.maps.water146.notes);assert_eq(again.links.water146.position,Vector2(999,470))
func test_invalid_or_unknown_state_is_rejected_never_migrated_silently():
 var state:=CountryLedger146.fresh(123,3);state.version=99;assert_false(CountryLedger146.valid(state,123,3));assert_eq(CountryLedger146.enter(state,Vector2.ZERO,456),{})
 state=CountryLedger146.fresh(123,3);assert_false(CountryLedger146.valid(state,124,3));assert_false(CountryLedger146.valid(state,123,2))
 state=CountryLedger146.enter(state,Vector2.ZERO,456);var map_:Dictionary=state.maps.water146;map_.position=Vector2(INF,0);assert_false(CountryLedger146.valid(state,123,3))
func test_prototype_domain_never_changes_live_save_or_collection():
 var before:Dictionary=SaveData.horse_collection.export_state().duplicate(true);var seed_:int=SaveData.world_seed;var pos:Vector2=SaveData.world_position
 var state:=CountryLedger146.enter(CountryLedger146.fresh(123,3),Vector2(999,470),456)
 CountryLedger146.leave(state,CountryRoute146.plan(456).entry)
 assert_eq(SaveData.horse_collection.export_state(),before);assert_eq(SaveData.world_seed,seed_);assert_eq(SaveData.world_position,pos)
