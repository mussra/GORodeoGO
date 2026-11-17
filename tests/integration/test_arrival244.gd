extends GutTest
var world:Node2D
var arrival:TownArrival244
var old_seed:int
var old_version:int
func before_each():
 old_seed=SaveData.world_seed;old_version=SaveData.world_generator_version
 SaveData.world_seed=752026;SaveData.world_generator_version=6
 world=Node2D.new();world.set_script(load('res://tests/integration/arrival_host244.gd'));add_child(world)
 arrival=world._arrival244
 await wait_process_frames(2)
func after_each():
 if arrival.active:arrival.finish(false)
 world.free();SaveData.world_seed=old_seed;SaveData.world_generator_version=old_version
 DirAccess.remove_absolute(TownArrival244.PREF_PATH);DirAccess.remove_absolute(WorldCamera243.PREF_PATH)
func plan()->Dictionary:return TownEnclosures227.plans(752026).town1
func test_full_bounds_fit_with_hud_margin_for_all_shapes():
 for item in TownEnclosures227.plans(752026).values():
  for extent in [Vector2(1280,720),Vector2(640,360),Vector2(1600,720)]:
   var zoom_:float=TownArrival244.fitted_zoom(item.bounds,extent)
   assert_lte((item.bounds.size.x+180)*zoom_,maxf(100,extent.x-100)+.01)
   assert_lte((item.bounds.size.y+180)*zoom_,maxf(100,extent.y-270)+.01)
func test_hold_center_is_fixed_one_second_while_player_still_moves():
 world._camera_controls243.set_factor(.85,false);arrival.begin(plan())
 arrival.elapsed=1.2;arrival.apply_frame();var zoom_:Vector2=arrival.camera.zoom
 var center:Vector2=world.player.global_position+arrival.camera.offset
 world.player.position+=Vector2(100,25);arrival.elapsed=2.19;arrival.apply_frame()
 assert_eq(arrival.camera.zoom,zoom_);assert_almost_eq(world.player.global_position.x+arrival.camera.offset.x,center.x,.01)
 assert_true(world.player.is_physics_processing());assert_false(get_tree().paused)
 arrival.elapsed=3.4;arrival.apply_frame();arrival.finish(true)
 assert_eq(arrival.camera.zoom,Vector2.ONE*.85);assert_eq(arrival.camera.offset,Vector2.ZERO)
func test_first_completed_arrival_is_persisted_with_seed_and_save_scope():
 arrival.begin(plan());arrival.finish(true);assert_true(arrival.seen.has(arrival.key('town1')))
 var cfg:=ConfigFile.new();assert_eq(cfg.load(TownArrival244.PREF_PATH),OK)
 assert_true((cfg.get_value('arrival','seen') as Dictionary).has(arrival.key('town1')))
 var key_:String=arrival.key('town1');SaveData.world_seed+=1;assert_ne(key_,arrival.key('town1'))
func test_manual_zoom_cancels_and_prevents_immediate_retry():
 arrival.begin(plan());arrival.elapsed=1.;arrival.apply_frame()
 world._camera_controls243.step(-1)
 assert_false(arrival.active);assert_eq(arrival.camera.zoom,Vector2.ONE*.85)
 assert_true(arrival.attempted.has(arrival.key('town1')));assert_false(arrival.seen.has(arrival.key('town1')))
func test_map_or_lasso_interrupt_restores_without_committing_seen():
 arrival.begin(plan());world._map_overlay.expanded=true;arrival._process(.1)
 assert_false(arrival.active);assert_eq(arrival.camera.zoom,Vector2.ONE)
 assert_false(arrival.seen.has(arrival.key('town1')))
func test_lod_hides_drawing_only_and_restores_previous_visibility():
 var decor=load('res://src/Presentation/world_decor.gd').new();decor.kind='tree';world.add_child(decor)
 var hidden=load('res://src/Presentation/world_decor.gd').new();hidden.kind='rock';world.add_child(hidden);hidden.hide()
 arrival.begin(plan());arrival.elapsed=1.;arrival.apply_frame()
 assert_false(decor.visible);assert_false(hidden.visible);assert_true(decor.can_process())
 arrival.finish(false);assert_true(decor.visible);assert_false(hidden.visible)
func test_nearby_check_runs_four_times_per_second_and_not_when_map_open():
 world._map_overlay.expanded=true
 for i in 10:arrival._process(.05)
 assert_eq(arrival.checks,2);assert_false(arrival.active)
 world._map_overlay.expanded=false;world.player.position=plan().gate+Vector2(0,200)
 arrival._process(.3);assert_true(arrival.active)
func test_approach_from_each_wall_segment_triggers_without_opening_gate():
 for candidate in TownEnclosures227.plans(752026).values():
  for segment in candidate.segments:
   arrival.attempted={};world.player.position=segment.a.lerp(segment.b,.5)
   arrival._process(.3);assert_true(arrival.active)
   arrival.finish(false)
func test_camera_panorama_does_not_change_plan_collision_or_actor_counts():
 var point_:Vector2=plan().segments[0].a.lerp(plan().segments[0].b,.5)
 var blocked_:bool=TownEnclosures227.blocked(752026,point_)
 var nodes:int=world.player.get_child_count()
 arrival.begin(plan());arrival.elapsed=1.;arrival.apply_frame()
 assert_eq(TownEnclosures227.blocked(752026,point_),blocked_)
 assert_eq(world.player.get_child_count(),nodes)
func test_completed_town_is_skipped_on_following_check():
 world.player.position=plan().gate;arrival.begin(plan());arrival.finish(true)
 arrival._process(.3);assert_false(arrival.active)
func test_exit_restores_zoom_offset_and_lod():
 world._camera_controls243.set_factor(.85,false)
 arrival.begin(plan());arrival.elapsed=1.;arrival.apply_frame()
 var camera:Camera2D=arrival.camera
 world.remove_child(arrival);arrival.free()
 assert_eq(camera.zoom,Vector2.ONE*.85);assert_eq(camera.offset,Vector2.ZERO)
 assert_false(world._camera_controls243.arrival_active244)
 arrival=TownArrival244.new();arrival.world=world;world.add_child(arrival);arrival.set_process(false)
func test_cinematic_curve_has_slow_ends_and_zero_endpoint_acceleration():
 assert_eq(TownArrival244.cinematic_curve(0),0.)
 assert_eq(TownArrival244.cinematic_curve(1),1.)
 assert_almost_eq(TownArrival244.cinematic_curve(.5),.5,.0001)
 assert_lt(TownArrival244.cinematic_curve(.1),.01)
 assert_gt(TownArrival244.cinematic_curve(.9),.99)
 var previous:float=0.
 for i in 101:
  var value:float=TownArrival244.cinematic_curve(i/100.)
  assert_gte(value,previous);previous=value
func test_osd_toggle_keeps_same_save_and_mode():
 var path_:String=SaveData.save_path;var mode_:bool=SaveData.debug_mode
 GameState.set_performance_osd245(true)
 assert_true(GameState.performance_osd245);assert_eq(SaveData.save_path,path_);assert_eq(SaveData.debug_mode,mode_)
 GameState.set_performance_osd245(false)
 assert_false(GameState.performance_osd245)
func test_main_menu_has_games_catalog_not_a_second_world_shortcut():
 var menu=load('res://src/Presentation/main_menu.tscn').instantiate();add_child(menu)
 assert_eq(menu._play.text,'JUEGOS');assert_ne(menu._world_button.text,menu._play.text)
 menu._play.pressed.emit();assert_not_null(menu._games213)
 menu.free()
func test_wide_manual_zoom_has_nine_levels_and_restores_decor():
 var before_count:int=world.player.get_child_count()
 for value in WorldCamera243.STEPS:
  world._camera_controls243.set_factor(value,false)
  assert_almost_eq(arrival.camera.zoom.x,value,.0001)
 assert_eq(world.player.get_child_count(),before_count)
 world._camera_controls243.set_factor(.25,false)
 var decor=load('res://src/Presentation/world_decor.gd').new();decor.kind='tree';world.add_child(decor)
 assert_false(decor.visible)
 world._camera_controls243.set_factor(1.,false)
 assert_true(decor.visible)
 assert_false(is_instance_valid(world._camera_controls243.overview246))
