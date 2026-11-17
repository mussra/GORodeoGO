extends "res://tests/integration/test_herd_migration226.gd"
func test_two_opposite_destinations_have_correct_positions_and_both_source_labels():
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_position=WorldNominal98.home()
 await launch()
 var candidates:Array=TownNetwork234.base_nodes(SaveData.world_seed).home.targets.values()
 var north:String="";var south:String=""
 var home_:Vector2=TownNetwork234.node_for(SaveData.world_seed,"home").door
 for id in candidates:
  var p:Vector2=TownNetwork234.node_for(SaveData.world_seed,id).door
  if p.y<home_.y-5000.:north=id
  if p.y>home_.y+5000.:south=id
 assert_false(north.is_empty());assert_false(south.is_empty())
 var state:=SaveData.world_cousins140.duplicate(true);state["routes249"]={}
 for role in TownNetwork234.base_nodes(SaveData.world_seed).home.targets:
  var target:String=TownNetwork234.base_nodes(SaveData.world_seed).home.targets[role]
  if target not in [north,south]:continue
  state.routes249["home|"+role]={"town":"home","role":role,"target":target};state.revealed215[target]=true
 # Stale saved display positions cannot collapse a real destination onto home.
 state.doors[north]=home_;state.doors[south]=home_;SaveData.world_cousins140=state
 var discovered:=SaveData.world_discovered.duplicate()
 var map:WorldDiscoveryMap159=world._map_overlay;map.expanded=true;map._layout();map._ensure_terrain()
 var n:Vector2=map._town_marker215(north);var s:Vector2=map._town_marker215(south)
 var center:Vector2=map._to_map(home_,map._map_geometry.data.mins,map._map_geometry.cell,map._map_geometry.origin-map._map_geometry.area.position)
 assert_lt(n.y,center.y-20.);assert_gt(s.y,center.y+20.)
 assert_gt(n.distance_to(s),80.)
 assert_false(TownRoutes249.source_label(state,north).is_empty());assert_false(TownRoutes249.source_label(state,south).is_empty())
 assert_eq(SaveData.world_discovered,discovered,"Fitting destinations does not discover the terrain")
 assert_true(SaveData.save_progress());SaveData.load_progress()
 assert_eq(TownRoutes249.destinations(SaveData.world_cousins140).size(),2)
func test_marker_routes_validate_real_offices_and_never_mix_target_with_sender():
 SaveData.world_generator_version=6;var seed_:int=SaveData.world_seed;var home_:Dictionary=TownNetwork234.base_nodes(seed_).home
 var role_:String=home_.targets.keys()[0];var target:String=home_.targets[role_]
 var raw:Dictionary={"fake":{"town":"home","role":"fake","target":target},"real":{"town":"home","role":role_,"target":target}}
 var clean:=TownRoutes249.clean(raw,seed_)
 assert_eq(clean.size(),1);assert_eq(clean["home|"+role_].target,target)
 var state:Dictionary={"seed":seed_,"routes249":clean}
 assert_true(TownRoutes249.source_label(state,target).begins_with(TownNetwork234.NAMES[role_]+" de "))
 assert_almost_eq(TownRoutes249.position_for(state,target).x,TownNetwork234.node_for(seed_,target).door.x,.001)
