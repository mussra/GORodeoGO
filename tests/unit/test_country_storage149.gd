extends GutTest
func test_v1_upgrade_preserves_identity_links_notes_position_visits_without_inventing_route():
 var state:=CountryLedger146.enter(CountryLedger146.fresh(123,3),Vector2(999,470),456);state.version=1;state.maps.water146.erase("explored");state.maps.water146.notes={"test":"pista"};state.maps.water146.visited.tree=true
 var original:=state.duplicate(true);var next:=CountryLedger146.upgrade(state);assert_eq(state,original);assert_eq(next.version,2);assert_eq(next.links,state.links);assert_eq(next.maps.water146.notes,state.maps.water146.notes);assert_eq(next.maps.water146.position,state.maps.water146.position);assert_true(next.maps.water146.visited.tree);assert_lte(next.maps.water146.explored.size(),9)
 var source:Vector2=CountryRoute146.plan(456).sites.source;assert_false(next.maps.water146.explored.has(Vector2i(floori(source.x/512.),floori(source.y/512.))))
func test_v2_rejects_malformed_out_of_bounds_non_bool_and_oversized_exploration():
 var state:=CountryLedger146.enter(CountryLedger146.fresh(123,3),Vector2.ZERO,456)
 for cells in [{"0,0":true},{Vector2i(-1,0):true},{Vector2i(25,0):true},{Vector2i(1,28):true},{Vector2i.ZERO:1},{Vector2i.ZERO:false}]:
  var bad:=state.duplicate(true);bad.maps.water146.explored=cells;assert_false(CountryLedger146.valid(bad,123,3));assert_eq(CountryLedger146.upgrade(bad),{})
func test_record_exploration_preserves_separate_maps_and_only_given_cells():
 var state:=CountryLedger146.enter(CountryLedger146.fresh(123,3),Vector2(999,470),456);var data:=CountryRoute146.plan(456);var cells:Dictionary={};CountryExploration148.reveal(cells,data.entry);CountryExploration148.reveal(cells,data.sites.source)
 var next:=CountryLedger146.record_exploration(state,data.sites.source,cells);assert_eq(next.maps.water146.explored,cells);assert_eq(state.maps.water146.explored,{});assert_eq(next.links,state.links);assert_true(next.maps.water146.visited.source);assert_false(next.maps.water146.visited.has("tree"))
