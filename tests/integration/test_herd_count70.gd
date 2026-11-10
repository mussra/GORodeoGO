extends GutTest
func test_real_loaded_world_keeps_every_uncaptured_herd_member()->void:
 SaveData.save_path="user://qa-herd70-isolated.dat";SaveData.world_seed=7781;SaveData.world_position=Vector2(-360,400);SaveData.world_edits.clear();SaveData.world_tamed.clear();SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child_autofree(world)
 while world._loading_world:await wait_process_frames(1)
 var total:int=0
 for key in world._chunks:
  var bits:Array=String(key).split(",");var cx:int=int(bits[0]);var cy:int=int(bits[1])
  var herd:Dictionary=WorldMap.generate(SaveData.world_seed,cx,cy).get("herd",{})
  if herd.is_empty():continue
  var members:Array=WorldHerd.members(herd,SaveData.world_seed,cx,cy)
  assert_gte(members.size(),3);total+=members.size()
 assert_eq(world._herd_horses.size(),total,"Los no capturados están todos en escena")
 for horse in world._herd_horses.values():assert_true(is_instance_valid(horse));assert_true(horse.visible)
 world.queue_free();await wait_process_frames(3)
