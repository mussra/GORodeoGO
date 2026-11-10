extends GutTest
func test_loading_reaches_same_nine_chunks_and_nearby_work_gate()->void:
 SaveData.save_path="user://qa-load67-test.dat";SaveData.world_seed=7781;SaveData.world_position=Vector2(-360,400);SaveData.world_edits=[];SaveData.world_tamed=[];SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child_autofree(world)
 var frames:int=0
 while world._loading_world and frames<600:await wait_process_frames(1);frames+=1
 assert_false(world._loading_world);assert_eq(world._chunks.size(),9);assert_true(world.player.is_physics_processing())
 var horse=load("res://src/Presentation/wild_horse.gd").new();horse.setup({"pos":world.player.position+Vector2(850,0),"traits":{"coat":1,"mane":0,"pattern":0,"finish":"normal"}});world.add_child(horse);horse.player_ref=world.player;horse.set_physics_process(false)
 var before=horse.position;horse._physics_process(.5);assert_eq(horse.position,before);assert_eq(horse._art.speed_scale,0.0)
 horse.roped=true;horse.held=2;horse._physics_process(.25);assert_almost_eq(horse.held,1.75,.01)
