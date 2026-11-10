extends GutTest
func test_real_world_animals_rope_and_corral_bull_art()->void:

 SaveData.save_path="user://qa-animals69-isolated.dat";SaveData.world_seed=7781;SaveData.world_position=Vector2(-360,400);SaveData.world_edits=[];SaveData.world_tamed=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child_autofree(world)
 var frames:int=0
 while world._loading_world and frames<600:await wait_process_frames(1);frames+=1
 assert_false(world._loading_world);assert_eq(world._chunks.size(),9)
 var pig=load("res://src/Presentation/wild_pig.gd").new();pig.setup({"pos":world.player.position+Vector2(100,0)});world.add_child(pig);pig.set_process(false)
 assert_true(pig.try_capture(pig.global_position));assert_false(pig.try_capture(pig.global_position+Vector2(500,0)))
 pig.roped=true;pig.rider=world.player;pig.held=2;pig._process(.25);assert_almost_eq(pig.held,1.75,.01);pig.release();assert_false(pig.roped);assert_eq(pig.BODY_RADIUS,28.0)
 var goat=load("res://src/Presentation/wild_goat.gd").new();goat.setup({"pos":world.player.position+Vector2(150,0)});world.add_child(goat);goat.set_process(false)
 assert_true(goat.try_capture(goat.global_position));goat.roped=true;goat.rider=world.player;goat.held=2;goat._process(.25);assert_almost_eq(goat.held,1.75,.01);goat.release();assert_false(goat.roped)
 for direction in [Vector2.RIGHT,Vector2(1,1),Vector2.DOWN,Vector2(-1,1),Vector2.LEFT,Vector2(-1,-1),Vector2.UP,Vector2(1,-1)]:
  pig.movement=direction;pig.state.flee=true;pig._process(0);goat.movement=direction;goat._process(0)
  assert_true(pig._art.animation.begins_with("run"));assert_true(goat.goat_art.animation.begins_with("run"))
 world.queue_free();await wait_process_frames(3)
 # Real corral scene, not a fabricated bull host: physics and art both exist.
 var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child_autofree(level);await wait_process_frames(3)
 var bulls:Array=level.all_bulls
 assert_gt(bulls.size(),0)
 for bull in bulls:
  for view in ["side","up","down","diag_up","diag_down"]:assert_eq(bull._sprite_swap._frames.get_frame_count("flee_"+view),9)
 level.queue_free();await wait_process_frames(3)
