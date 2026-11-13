extends GutTest
func _check_home(version:int):
 SaveData.country_ledger146={};SaveData.save_path="user://home148-regression.dat";SaveData._load_valid=true;SaveData.world_places144={};SaveData.world_generator_version=version;SaveData.trial_session_active=false;SaveData.horse_collection.seed_trial();SaveData.world_quests={};SaveData.world_seed=752026;SaveData.world_position=Vector2(14000,160);SaveData.world_discovered=[]
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child_autofree(world)
 while world._loading_world or get_tree().root.get_node_or_null("FrontierTransition")!=null:await wait_process_frames(1)
 var previous=SaveData.world_discovered.duplicate()
 world._home()
 # Since144 home is an explicit siesta confirmation, not an immediate teleport.
 assert_not_null(world._travel144.panel);assert_eq(world.player.position,Vector2(14000,160));world._travel144.close_confirmation()
 # An old distant save has no known connecting route. Siesta may not explore it.
 assert_false(await world._travel144.start("ranch"))
 assert_eq(world.player.position,Vector2(14000,160))
 assert_eq(world.player.velocity,Vector2.ZERO)
 assert_false(world._loading_world);assert_true(world.visible)
 var added=0
 for key in SaveData.world_discovered:
  if not previous.has(key):
   added+=1
   var c=WorldMap.chunk_at(WorldNominal98.home() if version>=2 else world.HOME_POS)
   var allowed=[]
   for dx in range(-1,2):
    for dy in range(-1,2):allowed.append(WorldMap.chunk_key(c.x+dx,c.y+dy))
   assert_has(allowed,key,"No discovery of chunks on the route between endpoints")
 assert_lte(added,9)
 DirAccess.remove_absolute(SaveData.save_path)

func test_home_loads_legacy_destination_without_visible_travel():await _check_home(1)
func test_home_loads_nominal_destination_without_visible_travel():await _check_home(3)
