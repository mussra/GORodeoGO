extends GutTest
func test_home_loads_only_destination_without_visible_travel():
 SaveData.trial_session_active=true;SaveData.horse_collection.seed_trial();SaveData.world_quests={};SaveData.world_seed=752026;SaveData.world_position=Vector2(14000,160);SaveData.world_discovered=[]
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child_autofree(world)
 while world._loading_world or get_tree().root.get_node_or_null("FrontierTransition")!=null:await wait_process_frames(1)
 var previous=SaveData.world_discovered.duplicate()
 world._home()
 assert_not_null(get_tree().root.get_node_or_null("FrontierTransition"))
 while world._returning_home or get_tree().root.get_node_or_null("FrontierTransition")!=null:await wait_process_frames(1)
 assert_lt(world.player.position.distance_to(world.HOME_POS),.01)
 assert_eq(world.player.velocity,Vector2.ZERO)
 assert_false(world._loading_world);assert_true(world.visible)
 var added=0
 for key in SaveData.world_discovered:
  if not previous.has(key):
   added+=1
   var c=WorldMap.chunk_at(world.HOME_POS)
   var allowed=[]
   for dx in range(-1,2):
    for dy in range(-1,2):allowed.append(WorldMap.chunk_key(c.x+dx,c.y+dy))
   assert_has(allowed,key,"No discovery of chunks on the route between endpoints")
 assert_lte(added,9)
