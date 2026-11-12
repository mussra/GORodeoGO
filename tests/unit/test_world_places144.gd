extends GutTest
func test_only_proximity_or_recorded_conversation_makes_site_available():
 var candidates:Array=[{"id":"ranch","name":"Rancho","pos":Vector2(0,160)},{"id":"east138","name":"Este","pos":Vector2(9000,470)}]
 var state:=WorldPlaces144.fresh(123,3)
 assert_false(WorldPlaces144.visit(state,Vector2(3000,0),candidates));assert_eq(WorldPlaces144.available(state,candidates),[])
 assert_true(WorldPlaces144.visit(state,Vector2(0,160),candidates));assert_eq(WorldPlaces144.available(state,candidates).size(),1)
 assert_true(WorldPlaces144.visit(state,Vector2(0,160),candidates,{"east138":true}));assert_eq(WorldPlaces144.available(state,candidates).size(),2)
 assert_false(WorldPlaces144.visit(state,Vector2(0,160),candidates,{"east138":true}));assert_eq(WorldPlaces144.destination(state,candidates,"unknown"),{})
func test_clean_seed_generator_and_invalid_rows_do_not_unlock_places():
 var state:=WorldPlaces144.fresh(123,3);state.visited={"ranch":true,"east138":true,"fake":true,"west140":"yes"}
 assert_eq(WorldPlaces144.clean(state,123,3).visited,{"ranch":true,"east138":true})
 assert_eq(WorldPlaces144.clean(state,124,3).visited,{})
 assert_eq(WorldPlaces144.clean(state,123,2).visited,{})
 assert_eq(WorldPlaces144.clean([],123,3).visited,{})
func test_sites_are_real_existing_maps_and_not_future_source_country():
 assert_eq(WorldPlaces144.sites(123,1,{}).size(),1)
 assert_eq(WorldPlaces144.sites(123,2,{}).size(),1)
 var cousins:=VillageCousins140.fresh(123,[],{"region":1,"door":Vector2(9000,358)})
 var sites:=WorldPlaces144.sites(123,3,cousins);assert_eq(sites.size(),4)
 assert_eq(sites.map(func(s):return s.id),["ranch","east138","west140","east140"])
 for site in sites:assert_true(site.pos.is_finite())
