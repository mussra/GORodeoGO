extends "res://tests/integration/test_herd_migration226.gd"
func test_new_world_uses_v4_and_keeps_v3_saved_worlds_on_their_generator():
 SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.country_ledger146={};SaveData.world_places144={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_roaming139={}
 SaveData.world_seed=0;assert_gt(SaveData.ensure_world_seed(),0);assert_eq(SaveData.world_generator_version,4)
 assert_true(SaveData.save_progress());SaveData.load_progress();assert_true(SaveData._load_valid);assert_eq(SaveData.world_generator_version,4)
 SaveData.world_generator_version=3;assert_true(SaveData.save_progress());SaveData.load_progress();assert_true(SaveData._load_valid);assert_eq(SaveData.world_generator_version,3)
func test_actual_player_crosses_gate_but_cannot_cross_visible_wall_in_v4():
 SaveData.world_generator_version=4;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_garden212=Garden212.fresh()
 var plan:Dictionary=TownEnclosures227.plans(7781).home;SaveData.world_position=plan.gate+Vector2(0,180)
 await launch();world.player.set_physics_process(false);world.player.position=plan.gate+Vector2(0,180);await wait_physics_frames(2)
 var collision=world.player.move_and_collide(Vector2(0,-360));assert_null(collision,"Open gate must be physically traversable");assert_lt(world.player.position.y,plan.gate.y)
 var segment:Dictionary=plan.segments[0]
 # Pick a loaded segment near the doorway, not a wall on the far side of town.
 var distance:float=INF
 for candidate in plan.segments:
  var mid:Vector2=(candidate.a+candidate.b)*.5;var d:float=mid.distance_to(plan.gate)
  if d<distance:segment=candidate;distance=d
 var mid:Vector2=(segment.a+segment.b)*.5;var normal:Vector2=(segment.b-segment.a).normalized().orthogonal()
 var c:=WorldMap.chunk_at(mid);world._activate_or_queue(c.x,c.y)
 while not world._build_queue.is_empty():world._step_chunk_build()
 for key in world._chunk_built.keys():world._activate_built(key)
 world.player.position=mid+normal*180.;await wait_physics_frames(2)
 collision=world.player.move_and_collide(-normal*360.);assert_not_null(collision,"Visible wall must stop the real player")
 if collision!=null:assert_true(collision.get_collider().is_in_group("world_mountain103"))
func test_actual_home_characters_buildings_and_garden_are_inside_and_clear_of_new_walls():
 SaveData.world_generator_version=4;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_garden212=Garden212.fresh();SaveData.world_position=WorldNominal98.home()
 await launch();var plan:Dictionary=TownEnclosures227.plans(7781).home
 var points:Array=[world.garden212.home,world.garden212.plot,world.garden212.sample,world.garden212.gardener.position,world.get_node("GanjoMusician205").position]
 for door in WorldNominal98.doors().values():points.append(ModularWorldLayout93.world(door))
 for data in world._npcs98():
  if str(data.id).contains("east") or (data.has("cousin140") and data.cousin140!="home"):continue
  points.append(data.position)
 for point in points:
  assert_true(Geometry2D.is_point_in_polygon(point,plan.polygon));assert_false(WorldTerrain103.blocked(7781,point,45.))
 assert_gt(points.size(),10)
