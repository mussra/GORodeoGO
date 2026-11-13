extends GutTest
var world:CountryPreview146
var previous:String
func before_each():
 SaveData.siesta_rest166=0.
 previous=SaveData.save_path;SaveData.save_path="user://country148.dat";SaveData.world_seed=123;SaveData.world_generator_version=3;SaveData.world_position=Vector2(999,470);SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.country_ledger146={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 assert_true(SaveData.save_progress());world=CountryPreview146.new();add_child(world);world.player.set_physics_process(false);await get_tree().physics_frame;world._process(0.)
func after_each():
 world.free();SaveData.save_path=previous;DirAccess.remove_absolute("user://country148.dat");await get_tree().process_frame
func visit_source():
 for path in [world.data.approach,world.data.upstream]:
  for i in range(1,path.size()):
   for j in ceili(path[i-1].distance_to(path[i])/200.)+1:CountryExploration148.reveal(world.visited_cells,path[i-1].move_toward(path[i],j*200.))
 world.player.position=world.data.sites.source;world._process(0.);world.player.position=world.data.entry;world._process(0.)
func test_unknown_site_rejected_and_home_stays_in_this_country():
 var origin:Vector2=world.player.position;assert_false(await world.start_siesta("source"));assert_eq(world.player.position,origin);assert_false(world.travelling)
 assert_eq(CountryLedger146.home(world.ledger).position,world.data.entry);assert_eq(CountryExploration148.available(world.ledger,world.data).size(),1)
func test_local_roundtrip_never_changes_frontier_disk_horses_or_unexplored_route():
 visit_source();var disk:=FileAccess.get_file_as_bytes(SaveData.save_path);var origin:Vector2=SaveData.world_position;var horses:=SaveData.horse_collection.export_state();var cells:Dictionary=world.visited_cells.duplicate(true)
 var expected:=SiestaRoute163.country(world.player.position,world.data.sites.source,world.data,world.visited_cells);assert_false(expected.is_empty())
 assert_true(await world.start_siesta("source"));assert_lt(world.player.position.distance_to(expected.pos),100.);world.preview_rest166=0.;var back:=SiestaRoute163.country(world.player.position,world.data.entry,world.data,world.visited_cells);assert_true(await world.start_siesta("entry"));assert_lt(world.player.position.distance_to(back.pos),100.)
 assert_eq(world.visited_cells,cells);assert_eq(world.ledger.maps.water146.visited.keys().size(),2);assert_false(world.ledger.maps.water146.visited.has("tree"));assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),disk);assert_eq(SaveData.world_position,origin);assert_eq(SaveData.country_ledger146,{});assert_eq(SaveData.horse_collection.export_state(),horses);assert_false(world.travelling);assert_true(world.touch_controls.visible)
func test_blocked_arrival_restores_country_origin_ledger_exploration_and_disk():
 visit_source();var origin:Vector2=world.player.position;var ledger:=world.ledger.duplicate(true);var cells:=world.visited_cells.duplicate(true);var disk:=FileAccess.get_file_as_bytes(SaveData.save_path)
 var blocker:=StaticBody2D.new();blocker.collision_layer=128;blocker.position=SiestaRoute163.country(origin,world.data.sites.source,world.data,world.visited_cells).pos;var shape:=CollisionShape2D.new();var rect:=RectangleShape2D.new();rect.size=Vector2(500,500);shape.shape=rect;blocker.add_child(shape);world.add_child(blocker);await get_tree().physics_frame
 assert_false(await world.start_siesta("source"));assert_eq(world.player.position,origin);assert_eq(world.ledger,ledger);assert_eq(world.visited_cells,cells);assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),disk);assert_eq(world.transaction.phase,"failed")
func test_map_uses_shared_gestures_known_sites_and_back_cancel():
 world.show_map();var map:CountryMap148=world.modal;map._layout();map._ensure_terrain();assert_eq(map.available159().map(func(site):return site.id),["entry"]);assert_false(world.touch_controls.visible)
 var point_:Vector2=map._to_map(world.data.entry,map._map_geometry.data.mins,map._map_geometry.cell,map._map_geometry.origin)
 var down:=InputEventScreenTouch.new();down.index=0;down.position=point_;down.pressed=true;map._gui_input(down)
 var drag:=InputEventScreenDrag.new();drag.index=0;drag.position=point_+Vector2(70,0);map._gui_input(drag)
 var up:=InputEventScreenTouch.new();up.index=0;up.position=drag.position;up.pressed=false;map._gui_input(up);await get_tree().process_frame;assert_eq(world.modal,map)
 map._gui_input(down);var second:=InputEventScreenTouch.new();second.index=1;second.position=point_+Vector2(30,0);second.pressed=true;map._gui_input(second);second.pressed=false;map._gui_input(second);up.position=point_;map._gui_input(up);await get_tree().process_frame;assert_eq(world.modal,map)
 point_=map._to_map(world.data.entry,map._map_geometry.data.mins,map._map_geometry.cell,map._map_geometry.origin);down.position=point_;up.position=point_;map._gui_input(down);map._gui_input(up);await get_tree().process_frame;await get_tree().process_frame;assert_true(world.modal is SiestaConfirmation148);assert_false(world.travelling)
 var back:=InputEventAction.new();back.action="ui_cancel";back.pressed=true;world.modal._unhandled_input(back);assert_null(world.modal);assert_true(world.touch_controls.visible);assert_eq(world.player.position,world.data.entry);assert_false(map.expanded);assert_true(map.visible)
func test_siesta_rejects_stun_and_capture_and_concurrency_without_exit():
 visit_source();world.player._stun_time_remaining=1.;assert_false(await world.start_siesta("source"));world.player._stun_time_remaining=0.
 world.travelling=true;assert_false(await world.start_siesta("source"));world.request_return();assert_true(world.travelling);world.travelling=false
 world.player.lasso._start_charging();assert_true(world.player.lasso.is_charging());assert_false(await world.start_siesta("source"));assert_true(world.player.lasso.is_charging());world.player.lasso._cancel_charge()
 world.player.lasso._lasso_in_flight=true;assert_false(await world.start_siesta("source"));assert_true(world.player.lasso._lasso_in_flight);world.player.lasso._lasso_in_flight=false
func test_modal_locks_player_and_selector_lists_only_visited_sites():
 world.player.set_physics_process(true);world.show_sites();assert_false(world.player.is_physics_processing());assert_eq(world.modal.entries.size(),1);assert_eq(world.modal.entries[0].id,"entry");assert_false(await world.start_siesta("entry"));world.close_modal();assert_true(world.player.is_physics_processing())
func test_safe_landing_uses_actual_shape_offset_and_country_terrain_callback():
 var body:=CharacterBody2D.new();body.collision_mask=128;world.add_child(body);body.position=Vector2(2000,2000)
 var shape:=CollisionShape2D.new();shape.name="CollisionShape2D";var rect:=RectangleShape2D.new();rect.size=Vector2(18,10);shape.shape=rect;shape.position=Vector2(100,0);body.add_child(shape)
 var wall:=StaticBody2D.new();wall.collision_layer=128;wall.position=body.position+shape.position;var hit:=CollisionShape2D.new();var box:=RectangleShape2D.new();box.size=Vector2(20,20);hit.shape=box;wall.add_child(hit);world.add_child(wall);await get_tree().physics_frame
 var landing:=TravelLanding148.find(body,body.position,func(_p):return false);assert_true(landing.is_finite());assert_ne(landing,body.position)
 assert_false(TravelLanding148.find(body,body.position,func(_p):return true).is_finite())
func test_eye_walks_without_manual_control_then_opens_only_after_commit():
 visit_source();var origin:Vector2=world.player.position;var expected:=SiestaRoute163.country(origin,world.data.sites.source,world.data,world.visited_cells);var state:Dictionary={"done":false,"ok":false}
 var run:Callable=func():state.ok=await world.start_siesta("source");state.done=true
 run.call_deferred();await get_tree().create_timer(.3,true).timeout
 assert_true(world.travelling);assert_false(world.player.is_physics_processing());assert_eq(world.curtain.phase,"closing");assert_gt(world.player.position.distance_to(origin),1.);assert_gt(world.curtain.eye.aperture,0.);assert_lt(world.curtain.eye.aperture,1.)
 Input.action_press("move_left");Input.action_press("move_down");var at:Vector2=world.player.position
 await get_tree().create_timer(.3,true).timeout;Input.action_release("move_left");Input.action_release("move_down");assert_gt(world.player.position.x,at.x);assert_lt(absf(world.player.position.y-origin.y),1.)
 while not state.done:await get_tree().process_frame
 assert_true(state.ok);assert_lt(world.player.position.distance_to(expected.pos),100.);assert_false(world.travelling);assert_null(world.curtain);assert_true(world.touch_controls.visible)
func test_blocked_initial_walk_restores_saved_origin_instead_of_pushing_through():
 visit_source();var origin:Vector2=world.player.position;var blocker:=StaticBody2D.new();blocker.collision_layer=128;blocker.position=origin+Vector2(40,0);var collision:=CollisionShape2D.new();var rect:=RectangleShape2D.new();rect.size=Vector2(20,120);collision.shape=rect;blocker.add_child(collision);world.add_child(blocker);await get_tree().physics_frame
 assert_false(await world.start_siesta("source"));assert_eq(world.player.position,origin);assert_false(world.travelling);assert_true(world.last_error.contains("bloqueado"));assert_null(world.curtain)
func test_unseen_connection_and_last_short_stretch_are_left_to_manual_exploration():
 var before:Vector2=world.player.position;world.ledger.maps.water146.visited.source=true;assert_false(await world.start_siesta("source"));assert_eq(world.player.position,before)
 world.player.position=world.data.entry+Vector2(100,0);world._process(0.);assert_false(await world.start_siesta("entry"));assert_eq(world.player.position,world.data.entry+Vector2(100,0))

var refusal_done166:bool=false
func _refuse166():
 assert_false(await world.start_siesta("source"));refusal_done166=true
func test_preview_repeat_refusal_is_isolated_and_does_not_move_or_touch_real_save():
 visit_source();world.preview_rest166=300.;SaveData.siesta_rest166=123.
 var origin:Vector2=world.player.position;var disk:=FileAccess.get_file_as_bytes(SaveData.save_path);var ledger:=world.ledger.duplicate(true)
 refusal_done166=false;_refuse166.call_deferred();await get_tree().create_timer(.7,true).timeout
 assert_true(world.travelling);assert_eq(world.curtain.phase,"refusing");assert_almost_eq(world.curtain.eye.aperture,.55,.01);assert_eq(world.curtain.message.text,SiestaRest166.REFUSAL);assert_false(world.player.is_physics_processing())
 world.request_return();assert_false(await world.start_siesta("entry"))
 while not refusal_done166:await get_tree().process_frame
 assert_eq(world.player.position,origin);assert_eq(world.ledger,ledger);assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),disk);assert_eq(SaveData.siesta_rest166,123.);assert_eq(world.preview_rest166,300.);assert_false(world.travelling)
