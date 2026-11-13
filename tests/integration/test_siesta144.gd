extends GutTest
var world:Node2D
func before_each():
 SaveData.save_path="user://siesta144.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_places144={};SaveData.world_discovered=[];SaveData.world_roaming139={};SaveData.world_tamed=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.country_ledger146={};SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false);world._travel144.record_visits()
func after_each():
 get_tree().paused=false;world.free();await get_tree().process_frame;DirAccess.remove_absolute(SaveData.save_path)
func unlock(id:String):
 for x in range(-8,15):
  for y in range(-1,2):
   var key:=WorldMap.chunk_key(x,y)
   if not SaveData.world_discovered.has(key):SaveData.world_discovered.append(key)
 var state:=WorldPlaces144.clean(SaveData.world_places144,SaveData.world_seed,3);state.visited[id]=true;assert_true(SaveData.commit_places144(state,world.player.position))
func test_visit_not_chunk_discovery_and_persistence():
 assert_eq(world._travel144.available().map(func(s):return s.id),["ranch"])
 var site:Dictionary=world._travel144.candidates()[1];SaveData.world_discovered.append(WorldMap.chunk_key(WorldMap.chunk_at(site.pos).x,WorldMap.chunk_at(site.pos).y));world._travel144.record_visits();assert_eq(world._travel144.available().size(),1)
 world.player.position=site.pos;world._travel144.visit_clock=0.;world._travel144.record_visits();assert_eq(world._travel144.available().size(),2)
 SaveData.load_progress();assert_true(SaveData.world_places144.visited.has(site.id))
func test_no_capture_release_and_no_unknown_destination():
 var origin:Vector2=world.player.position
 world._lasso_state="hold";assert_false(await world._travel144.start("ranch"));assert_eq(world._lasso_state,"hold");assert_eq(world.player.position,origin);world._lasso_state=""
 assert_false(await world._travel144.start("east138"));assert_eq(world.player.position,origin)
func test_real_round_trip_preserves_quests_mount_and_no_intermediate_discovery():
 unlock("east138");var site:Dictionary=world._travel144.candidates()[1];var origin:Vector2=world.player.position
 var horses:=SaveData.horse_collection.export_state();var quests:Dictionary=SaveData.world_quests.duplicate(true)
 var expected:=SiestaRoute163.frontier(origin,site.pos);assert_false(expected.is_empty());var discovered:=SaveData.world_discovered.duplicate()
 assert_true(await world._travel144.start("east138"));assert_lt(world.player.position.distance_to(expected.pos),100.);assert_gt(world.player.position.distance_to(site.pos),120.);assert_eq(SaveData.world_discovered,discovered);assert_false(get_tree().paused);assert_false(world._travel144.active)
 var saved:=ConfigFile.new();assert_eq(saved.load(SaveData.save_path),OK);assert_lt((saved.get_value("world","position") as Vector2).distance_to(expected.pos),100.);assert_eq(SaveData.horse_collection.export_state(),horses);assert_eq(SaveData.world_quests,quests)
 var back:=SiestaRoute163.frontier(world.player.position,origin);assert_true(await world._travel144.start("ranch"));assert_lt(world.player.position.distance_to(back.pos),100.)
func test_failed_origin_save_does_not_move_or_pause():
 unlock("east138");var path:String=SaveData.save_path;SaveData.save_path="user://missing144/save.dat";var origin:Vector2=world.player.position
 assert_false(await world._travel144.start("east138"));assert_push_error_count(1);assert_eq(world.player.position,origin);assert_false(get_tree().paused);SaveData.save_path=path
func test_destination_save_failure_rolls_back_origin():
 unlock("east138");var origin:Vector2=world.player.position
 # Origin save succeeds, then final arrival save is made unavailable during the cover.
 var fail:=get_tree().create_timer(.25,true);fail.timeout.connect(func():SaveData._load_valid=false)
 assert_false(await world._travel144.start("east138"));assert_true(world._travel144.rollback);assert_eq(world.player.position,origin);assert_eq(SaveData.world_position,origin);assert_false(get_tree().paused);SaveData._load_valid=true
func test_confirmation_cancel_and_map_marker_do_not_travel():
 world._map_overlay.expanded=true;world._map_overlay._layout();world._map_overlay._ensure_terrain()
 var site:Dictionary=world._travel144.available()[0];var map=world._map_overlay;var point:Vector2=map._to_map(site.pos,map._map_geometry.data.mins,map._map_geometry.cell,map._map_geometry.origin)
 map._select_site144(point);assert_not_null(world._travel144.panel);assert_false(world._travel144.active)
 world._travel144.close_confirmation();assert_null(world._travel144.panel);assert_false(world.player.is_physics_processing());world._map_overlay.expanded=false
func test_native_touch_selects_visited_marker_but_drag_and_pinch_do_not():
 world._map_overlay.expanded=true;world._map_overlay._layout();world._map_overlay._ensure_terrain();var map=world._map_overlay
 var site:Dictionary=world._travel144.available()[0];var point:Vector2=map._to_map(site.pos,map._map_geometry.data.mins,map._map_geometry.cell,map._map_geometry.origin)
 var press:=InputEventScreenTouch.new();press.index=0;press.pressed=true;press.position=point;map._gui_input(press)
 var release:=InputEventScreenTouch.new();release.index=0;release.pressed=false;release.position=point;map._gui_input(release)
 assert_not_null(world._travel144.panel);world._travel144.close_confirmation();await get_tree().process_frame
 map._gui_input(press);var drag:=InputEventScreenDrag.new();drag.index=0;drag.position=point+Vector2(80,0);drag.relative=Vector2(80,0);map._gui_input(drag);release.position=drag.position;map._gui_input(release);assert_null(world._travel144.panel)
 map._gui_input(press);var second:=InputEventScreenTouch.new();second.index=1;second.pressed=true;second.position=point+Vector2(80,0);map._gui_input(second);second.pressed=false;map._gui_input(second);release.position=point;map._gui_input(release);assert_null(world._travel144.panel)
func test_all_four_sites_safe_landings_on_multiple_seeds_and_legacy_home():
 # Existing V3 towns only. The position must be on the shared main road, clear of mountains.
 for seed_ in [123,752026,987654]:
  var flora:=FloristJourney138.fresh([]);var cousins:=VillageCousins140.fresh(seed_,[],flora)
  for site in WorldPlaces144.sites(seed_,3,cousins):assert_false(WorldTerrain103.blocked(seed_,site.pos,14.),str(site))
 assert_eq(WorldPlaces144.sites(123,1,{})[0].pos,Vector2(0,160))
func test_travel_rejects_ongoing_transitions_and_records_save_failure_atomically():
 var before:Dictionary=SaveData.world_places144.duplicate(true);var pos:Vector2=SaveData.world_position;var path:String=SaveData.save_path
 SaveData.save_path="user://missing144/visits.dat";var after:=before.duplicate(true);after.visited.east138=true
 assert_false(SaveData.commit_places144(after,Vector2(5000,470)));assert_push_error_count(1);assert_eq(SaveData.world_places144,before);assert_eq(SaveData.world_position,pos);SaveData.save_path=path
 world._travel144.active=true;assert_false(await world._travel144.start("ranch"));world._travel144.active=false
func test_blocked_destination_returns_to_saved_origin_without_unlocking_route():
 unlock("east138");var origin:Vector2=world.player.position;var site:Dictionary=world._travel144.candidates()[1]
 var blocker:=StaticBody2D.new();blocker.collision_layer=world.player.collision_mask;var shape:=CollisionShape2D.new();var rectangle:=RectangleShape2D.new();rectangle.size=Vector2(500,500);shape.shape=rectangle;blocker.add_child(shape);world.add_child(blocker);blocker.position=SiestaRoute163.frontier(origin,site.pos).pos
 await get_tree().physics_frame
 assert_false(await world._travel144.start("east138"));assert_true(world._travel144.rollback);assert_eq(world.player.position,origin);assert_false(get_tree().paused)
 var saved:=ConfigFile.new();assert_eq(saved.load(SaveData.save_path),OK);assert_eq(saved.get_value("world","position"),origin)
func test_old_distant_save_gets_only_starting_ranch_not_all_discovered_towns():
 SaveData.world_places144={};world.player.position=Vector2(15000,470);world._travel144.visit_clock=0.;world._travel144.record_visits()
 assert_eq(world._travel144.available().map(func(s):return s.id),["ranch"])

func test_android_back_cancels_confirmation_without_travel():
 world._travel144.choose("ranch");assert_not_null(world._travel144.panel)
 var event:=InputEventAction.new();event.action="ui_cancel";event.pressed=true
 world._travel144._unhandled_input(event);assert_null(world._travel144.panel);assert_false(world._travel144.active)
