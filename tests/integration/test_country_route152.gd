extends GutTest
var frontier:Node2D
var session:CountrySession152
var previous:String
func before_each():
 previous=SaveData.save_path;SaveData.save_path="user://route152.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_position=WorldNominal98.home();SaveData.country_ledger146={};SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_places144={};SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
func after_each():
 if is_instance_valid(session):session.free()
 if is_instance_valid(frontier):frontier.free()
 SaveData._load_valid=true;SaveData.country_ledger146={};SaveData.save_path=previous;DirAccess.remove_absolute("user://route152.dat");await get_tree().process_frame
func start_frontier():
 frontier=load("res://src/Presentation/frontier_world.gd").new();add_child(frontier)
 while frontier._loading_world:await get_tree().process_frame
 frontier.player.set_physics_process(false)
func find_session()->CountrySession152:
 for child in get_tree().root.get_children():
  if child is CountrySession152:return child
 return null
func test_real_frontier_entry_country_home_and_exit_preserve_original_state():
 await start_frontier();var origin:Vector2=frontier.player.position;var camera_=get_viewport().get_camera_2d();var horses:=SaveData.horse_collection.export_state()
 assert_true(await frontier._start_country152());session=find_session();assert_not_null(session);session.player.set_physics_process(false);assert_false(frontier.visible);assert_eq(frontier.process_mode,Node.PROCESS_MODE_DISABLED);assert_eq(SaveData.country_ledger146.active,"water146")
 for path in [session.data.approach,session.data.upstream]:
  for i in range(1,path.size()):
   for j in ceili(path[i-1].distance_to(path[i])/200.)+1:CountryExploration148.reveal(session.visited_cells,path[i-1].move_toward(path[i],j*200.))
 var discovered:=SaveData.world_discovered.duplicate();var quests:=SaveData.world_quests.duplicate(true);session.player.position=session.data.sites.source;session._process(0.);assert_true(session.save_now152());var expected:=SiestaRoute163.country(session.player.position,session.data.entry,session.data,session.visited_cells);assert_true(await session.start_siesta("entry"));assert_lt(session.player.position.distance_to(expected.pos),100.)
 await session.request_return();await get_tree().process_frame;assert_true(frontier.visible);assert_eq(frontier.player.position,origin);assert_eq(SaveData.world_position,origin);assert_eq(SaveData.world_discovered,discovered);assert_eq(SaveData.world_quests,quests);assert_eq(SaveData.horse_collection.export_state(),horses);assert_eq(SaveData.country_ledger146.active,"frontier");assert_eq(get_viewport().get_camera_2d(),camera_)
func test_cold_frontier_reload_reopens_saved_country_then_returns_to_linked_origin():
 await start_frontier();var origin:Vector2=frontier.player.position;assert_true(await frontier._start_country152());session=find_session();session.player.set_physics_process(false);session.player.position=session.data.sites.source;session._process(0.);assert_true(session.save_now152());var state:=SaveData.country_ledger146.duplicate(true)
 session.free();frontier.free();await get_tree().process_frame;SaveData.load_progress();await start_frontier()
 for i in 10:await get_tree().process_frame
 session=find_session();assert_not_null(session);session.player.set_physics_process(false);assert_true(session.activated);assert_eq(session.player.position,state.maps.water146.position);assert_eq(session.visited_cells,state.maps.water146.explored);assert_false(frontier.visible)
 await session.request_return();await get_tree().process_frame;assert_true(frontier.visible);assert_eq(frontier.player.position,origin);assert_eq(SaveData.country_ledger146.active,"frontier")
func test_failed_entry_durable_origin_save_keeps_current_frontier_playable():
 await start_frontier();var origin:Vector2=frontier.player.position;SaveData.save_path="user://missing152route/save.dat"
 assert_false(await frontier._start_country152());assert_push_error_count(1);assert_null(find_session());assert_true(frontier.visible);assert_eq(frontier.player.position,origin);assert_eq(SaveData.country_ledger146,{})
func test_failed_country_exit_save_stays_in_country_with_source_hidden():
 await start_frontier();assert_true(await frontier._start_country152());session=find_session();session.player.set_physics_process(false);var state:=SaveData.country_ledger146.duplicate(true);SaveData._load_valid=false
 await session.request_return();assert_true(is_instance_valid(session));assert_false(frontier.visible);assert_false(session.travelling);assert_eq(SaveData.country_ledger146,state);assert_true(session.touch_controls.visible)
func test_blocked_original_arrival_does_not_exit_country_or_rewrite_origin():
 await start_frontier();assert_true(await frontier._start_country152());session=find_session();session.player.set_physics_process(false);var origin:Vector2=frontier.player.position
 var blocker:=StaticBody2D.new();blocker.collision_layer=frontier.player.collision_mask;blocker.position=origin;var shape:=CollisionShape2D.new();var rect:=RectangleShape2D.new();rect.size=Vector2(500,500);shape.shape=rect;blocker.add_child(shape);frontier.add_child(blocker);await get_tree().physics_frame
 var disk:=FileAccess.get_file_as_bytes(SaveData.save_path);await session.request_return();assert_true(is_instance_valid(session));assert_false(frontier.visible);assert_eq(SaveData.country_ledger146.active,"water146");assert_eq(SaveData.world_position,origin);assert_eq(FileAccess.get_file_as_bytes(SaveData.save_path),disk)

func test_failed_cold_resume_blocks_frontier_instead_of_playing_wrong_map():
 await start_frontier();assert_true(await frontier._start_country152());session=find_session();var state:=SaveData.country_ledger146.duplicate(true)
 session.free();frontier.free();await get_tree().process_frame;SaveData._load_valid=false;await start_frontier()
 for i in 16:await get_tree().process_frame
 assert_null(find_session());assert_eq(SaveData.country_ledger146,state);assert_eq(frontier.process_mode,Node.PROCESS_MODE_DISABLED);assert_false(frontier.player.is_physics_processing());var found:=false
 for node in frontier.find_children("*","Label",true,false):
  if node.text=="No se pudo reabrir el país. Su progreso sigue guardado.":found=true
 assert_true(found)
