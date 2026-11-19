extends "res://tests/integration/test_herd_migration226.gd"
func test_real_player_crosses_all_four_loaded_cardinal_openings():
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_garden212=Garden212.fresh()
 var plan:Dictionary=TownEnclosures227.plans(7781).home
 SaveData.world_position=plan.gate+Vector2(0,180)
 await launch();world.player.set_physics_process(false)
 for name_ in plan.gates:
  var entry:Dictionary=plan.gates[name_];var normal:Vector2=entry.outward
  var mouth:Vector2=(entry.posts[0]+entry.posts[1])*.5
  world.player.position=mouth+normal*100.;world._update_chunks()
  for distance in [-100.,0.,100.]:
   var c:=WorldMap.chunk_at(mouth+normal*distance);world._activate_or_queue(c.x,c.y)
  while not world._build_queue.is_empty():world._step_chunk_build()
  for key in world._chunk_built.keys():world._activate_built(key)
  await wait_physics_frames(2)
  var collision=world.player.move_and_collide(-normal*200.)
  assert_null(collision,'Player crosses '+name_+' with actual colliders loaded')
  assert_lt((world.player.position-mouth).dot(normal),-80.)
func test_saved_player_on_rebuilt_wall_is_moved_to_clear_ground_before_loading():
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_garden212=Garden212.fresh()
 var plan:Dictionary=TownEnclosures227.plans(7781).home
 var segment:Dictionary=plan.segments[0]
 var blocked:Vector2=(segment.a+segment.b)*.5
 SaveData.world_position=blocked
 assert_true(WorldTerrain103.blocked(7781,blocked,20.))
 await launch()
 assert_false(WorldTerrain103.blocked(7781,world.player.position,20.))
 assert_gt(world.player.position.distance_to(blocked),20.)
