extends GutTest
class TerrainWorld extends Node2D:
 var seed:int=42
 func road_surface_contains94(_p:Vector2,_margin:float=0.)->bool:return false
 func mountain_step103(a:Vector2,b:Vector2)->Vector2:return WorldTerrain103.safe_step(seed,a,b)
 func mountain_spawn103(p:Vector2)->Vector2:return WorldTerrain103.clear_spawn(seed,p)
func test_actual_horse_pig_goat_flee_charge_and_rope_cannot_cross_ridge():
 var world=TerrainWorld.new();add_child_autofree(world)
 var ridge=WorldTerrain103.ridge(42,0)
 for script in [load("res://src/Presentation/wild_horse.gd"),load("res://src/Presentation/wild_pig.gd"),load("res://src/Presentation/wild_goat.gd")]:
  var start:Vector2=ridge.port+Vector2(-200,180)
  var animal=script.new();animal.setup({"pos":start,"traits":{"coat":1,"pattern":0,"mane":0,"eyes":0}});world.add_child(animal);animal.set_process(false);animal.set_physics_process(false)
  await get_tree().physics_frame
  for i in 80:
   if "herd" in animal:animal.flee_velocity(Vector2(230,0),false);animal._physics_process(.05)
   elif "IS_GOAT" in animal:animal.move_from_or_towards(start-Vector2(300,0),.05,false)
   else:animal.flee_from(start-Vector2(300,0),.05,230.)
   assert_false(WorldTerrain103.blocked(42,animal.global_position,17.))
  assert_lt(animal.position.x,ridge.x-45.)
  if not "herd" in animal:
   animal.roped=true
   for i in 30:
    if "IS_GOAT" in animal:animal.move_from_or_towards(start+Vector2(1000,0),.1,true)
    else:animal.flee_from(start-Vector2(1000,0),.1,230.)
    assert_false(WorldTerrain103.blocked(42,animal.global_position,17.))
  animal.free()
func test_chunk_solids_collide_at_wall_but_not_in_port():
 var world=Node2D.new();add_child_autofree(world)
 var mountains=WorldMountains103.new();mountains.seed=42;mountains.chunk=Vector2i(1,0);world.add_child(mountains)
 var ridge=WorldTerrain103.ridge(42,0)
 var rider=load("res://src/Presentation/world_player.gd").new();world.add_child(rider);rider.set_physics_process(false)
 assert_ne(rider.collision_mask & 128,0)
 for dy in [0.,180.]:
  rider.position=ridge.port+Vector2(-200,dy)
  await get_tree().physics_frame
  for i in 90:
   rider.velocity=Vector2(400,0);rider.move_and_slide();await get_tree().physics_frame
  if dy==0.:assert_gt(rider.position.x,ridge.x+100.)
  else:assert_lt(rider.position.x,ridge.x-40.)
func test_v3_roundtrip_without_changing_v2():
 var save=load("res://src/Application/save_data.gd").new();add_child_autofree(save);save.save_path="user://mountains103.dat";save.trial_session_active=false
 for version in [1,2,3]:
  save.world_generator_version=version;save.world_seed=752026;save.world_position=Vector2(1900,470);save.world_discovered.assign(["0,0","1,0"])
  assert_true(save.save_progress());save.load_progress();assert_eq(save.world_generator_version,version);assert_eq(save.world_position,Vector2(1900,470));assert_eq(save.world_discovered.size(),2)
 DirAccess.remove_absolute(save.save_path)
