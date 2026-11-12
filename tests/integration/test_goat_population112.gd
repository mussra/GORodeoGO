extends GutTest
func test_stream_generated_goats_share_alert_capture_and_ids():
 SaveData.save_path="user://goat112-only.dat";SaveData.trial_session_active=true;SaveData.world_generator_version=3;SaveData.world_seed=752026;SaveData.world_goat_captures=[];SaveData.world_edits=[];SaveData.world_quests={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_physics_process(false);world.set_process(false);world.player.set_physics_process(false)
 assert_gt(world._prototype_goats.get_child_count(),0,"V3 streamed groups, not fixed trio")
 var goat=world._prototype_goats.get_child(0);assert_true(str(goat.get_meta("capture_id112","")).begins_with("goat:v3:"))
 var origin:Vector2=goat.position;world.player.position=origin+Vector2(-150,0);world.player.velocity=Vector2.ZERO
 world._occluders.clear();world._cover_dirty110=true;world._tick_taming(.01)
 world._tick_goats(.1);assert_true(goat.state.alert110);assert_eq(goat.movement,Vector2.ZERO)
 world.player.velocity=Vector2.RIGHT*260
 for tick in 8:world._tick_goats(.1)
 assert_gt(goat.position.distance_to(origin),1.)
 var id:String=goat.get_meta("capture_id112");SaveData.trial_session_active=false;assert_true(SaveData.record_goat104(id));SaveData.load_progress();assert_true(SaveData.world_goat_captures.has(id))
 world.free()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 for item in world._prototype_goats.get_children():assert_ne(str(item.get_meta("capture_id112","")),id,"captured ID never respawns on reload")
 world.free();DirAccess.remove_absolute(SaveData.save_path)
