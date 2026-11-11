extends GutTest
func test_actual_world_shop_access_collision_and_no_quest_or_edit_mutation():
 SaveData.save_path="user://florist-integration-only.dat";SaveData.world_seed=752026;SaveData.world_position=Vector2(680,470);SaveData.world_edits=[];SaveData.world_quests={};SaveData.horse_collection.seed_trial()
 var before_edits=SaveData.world_edits.duplicate(true);var before_quests=SaveData.world_quests.duplicate(true)
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child_autofree(world)
 var count=0
 while world._loading_world and count<600:await wait_process_frames(1);count+=1
 assert_false(world._loading_world);world.player.set_physics_process(false)
 assert_true(world.has_node("FloristShopArt"));assert_true(world.has_node("FloristArt"));assert_true(world.has_node("FloristShopBody"))
 assert_eq(world.get_node("FloristArt").texture,WorldFloristShop.FLORIST)
 var flowers=0
 for node in world.get_children():
  if str(node.name).begins_with("FloristFlowers"):flowers+=1
 assert_eq(flowers,18)
 var lane=WorldPaths.florist_lane(SaveData.world_seed)
 for i in lane.size()-1:
  for n in int(ceil(lane[i].distance_to(lane[i+1])/4.0)):
   world.player.position=lane[i].lerp(lane[i+1],n/ceil(lane[i].distance_to(lane[i+1])/4.0))
   assert_false(world.player.test_move(world.player.global_transform,(lane[i+1]-lane[i]).normalized()*4),"clear access "+str(world.player.position))
 world.player.position=WorldFloristShop.DOOR
 assert_true(world.player.test_move(world.player.global_transform,Vector2(0,-70)),"building is solid behind threshold")
 assert_eq(SaveData.world_edits,before_edits);assert_eq(SaveData.world_quests,before_quests)
