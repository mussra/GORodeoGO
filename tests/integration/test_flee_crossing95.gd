extends GutTest
const Horse=preload("res://src/Presentation/wild_horse.gd")
const Pig=preload("res://src/Presentation/wild_pig.gd")
const Goat=preload("res://src/Presentation/wild_goat.gd")
func test_escape_crosses_but_spawn_and_ordinary_behavior_stay_off_in_all_worlds():
 SaveData.horse_collection.seed_trial()
 for mode in ["frontier","light","dark"]:
  var world:Node2D
  if mode=="frontier":
   SaveData.save_path="user://cross95.dat";SaveData.trial_session_active=true;SaveData.world_generator_version=1;SaveData.world_seed=752026;SaveData.world_position=Vector2(100,180);SaveData.world_edits=[]
   world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
   while world._loading_world:await get_tree().process_frame
  else:
   world=load("res://src/Presentation/modular_world93.tscn").instantiate();add_child(world);world.dark=mode=="dark";world._reload_art()
  world.set_process(false);world.set_physics_process(false)
  var center:Vector2=Vector2(400,WorldMap.trail_y_at(752026,400)) if mode=="frontier" else ModularWorldLayout93.world(Vector2i(9,4))
  for script in [Horse,Pig,Goat]:
   var animal=script.new();animal.setup({"pos":center+Vector2(0,-70),"traits":{"coat":1,"pattern":0,"mane":0,"eyes":0}});world.add_child(animal);animal.set_process(false);animal.set_physics_process(false)
   await get_tree().physics_frame
   assert_false(world.road_surface_contains94(animal.global_position,18.),"spawn avoids "+mode)
   var start:Vector2=animal.position
   var touched:bool=false
   for i in 60:
    if script==Horse:animal.flee_from(start-Vector2(0,100),.05);animal._physics_process(.05)
    elif script==Goat:animal.move_from_or_towards(start-Vector2(0,100),.05,false)
    else:animal.flee_from(start-Vector2(0,100),.05,230.)
    touched=touched or world.road_surface_contains94(animal.global_position)
   assert_true(touched,"flee enters road "+mode+str(script))
   assert_gt(animal.position.y,center.y+20.,"flee crosses to other side")
   # Ordinary approach/charge must not start a new crossing.
   animal.position=start
   if script!=Horse:animal._escape_left95=0.
   for i in 50:
    if script==Horse:animal.approach(start+Vector2(0,200),.05);animal._physics_process(.05)
    elif script==Goat:animal.move_from_or_towards(start+Vector2(0,200),.05,true)
    else:animal._settle_offroad95(.05)
    assert_false(world.road_surface_contains94(animal.global_position,18.),"ordinary movement stays off")
   if script==Horse:
    animal.position=start
    for i in 60:
     animal.flee_velocity(Vector2(0,230),false);animal._physics_process(.05)
    assert_gt(animal.position.y,center.y+20.,"herd fleeing may cross even without panic")
    animal.position=center;animal.wander=true;animal._flee=Vector2.ZERO;animal._escape_roads95=false;animal._wander_target=center+Vector2(0,-100)
    for i in 80:animal._physics_process(.05)
    assert_false(world.road_surface_contains94(animal.global_position,18.),"exit to verge after fleeing")
   else:
    animal.position=center;animal._escape_left95=0.
    for i in 40:animal._settle_offroad95(.05)
    assert_false(world.road_surface_contains94(animal.global_position,18.),"pig/goat returns to grass")
   animal.free()
  world.free()
