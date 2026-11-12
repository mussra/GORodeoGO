extends GutTest
const Horse=preload("res://src/Presentation/wild_horse.gd")
const Pig=preload("res://src/Presentation/wild_pig.gd")
const Goat=preload("res://src/Presentation/wild_goat.gd")
func _animals(node:Node)->Array:
 var out:Array=[]
 if node.get_script() in [Horse,Pig,Goat]:out.append(node)
 for child in node.get_children():out.append_array(_animals(child))
 return out
func _spawn(world:Node2D,script:Script,point:Vector2)->Node2D:
 var animal=script.new()
 animal.setup({"pos":point,"traits":{"coat":1,"pattern":0,"mane":0,"eyes":0,"finish":"normal"}})
 world.add_child(animal)
 animal.set_physics_process(false);animal.set_process(false)
 return animal
func _check_motion(world:Node2D,animal:Node2D,threat:Vector2):
 for i in 40:
  var before:Vector2=animal.global_position
  if animal.get_script()==Horse:
   animal.approach(threat,.1)
   animal._physics_process(.1)
  elif animal.get_script()==Goat:animal.move_from_or_towards(threat,.1,true)
  else:animal._settle_offroad95(.1)
  assert_false(world.road_surface_contains94(animal.global_position,WorldWildRoads94.FOOTPRINT),"animal footprint stays off road")
  assert_true(WorldWildRoads94.segment_clear(before,animal.global_position,animal.road_provider94),"no jumping across road")
func test_modular_spawn_flee_charge_wander_and_stamina_both_art_sets():
 SaveData.horse_collection.seed_trial()
 var edits=SaveData.world_edits.duplicate(true);var saved=SaveData.world_position
 var world=load("res://src/Presentation/modular_world93.tscn").instantiate();add_child_autofree(world)
 world.set_physics_process(false)
 for a in _animals(world):a.set_physics_process(false)
 for dark in [false,true]:
  world.dark=dark;world._reload_art()
  for existing in _animals(world):
   assert_false(world.road_surface_contains94(existing.global_position,18.))
  for cell in ModularWorldLayout93.graph():
   var animal=_spawn(world,Horse,ModularWorldLayout93.world(cell))
   assert_false(world.road_surface_contains94(animal.global_position,18.),"all tile kinds spawn off soil")
   animal.free()
  for script in [Horse,Pig,Goat]:
   var animal=_spawn(world,script,ModularWorldLayout93.world(Vector2i(9,4)))
   _check_motion(world,animal,ModularWorldLayout93.world(Vector2i(9,4))+Vector2(0,-100))
   if script==Horse:
    animal.wander=true;animal._flee=Vector2.ZERO;animal._wander_target=ModularWorldLayout93.world(Vector2i(9,4));animal._wander_pause=0.
    for i in 80:
     animal._physics_process(.1)
     assert_false(world.road_surface_contains94(animal.global_position,18.),"wander stays off road")
   animal.free()
  world.player.position=ModularWorldLayout93.world(Vector2i(9,4));world.player.velocity=Vector2(100,0);world.player.gait=WorldGait.GALOPE
  world.stamina={"value":50.,"max":100.,"forced_left":0.};world._physics_process(1.)
  assert_almost_eq(float(world.stamina.value),50.-4.*WorldStamina.ROAD_DRAIN_MULT,.001)
  world.player.position=Vector2(1000,100);world.stamina={"value":50.,"max":100.,"forced_left":0.};world._physics_process(1.)
  assert_almost_eq(float(world.stamina.value),46.,.001)
 assert_eq(SaveData.world_edits,edits);assert_eq(SaveData.world_position,saved)
func test_real_frontier_spawn_and_ordinary_motion_avoids_roads():
 SaveData.save_path="user://road94-isolated-test.dat";SaveData.trial_session_active=true;SaveData.world_generator_version=1;SaveData.world_seed=752026;SaveData.world_edits=[];SaveData.world_position=Vector2(100,180);SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child_autofree(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var animals:Array=_animals(world)
 assert_gt(animals.size(),4)
 for animal in animals:
  animal.set_process(false);animal.set_physics_process(false)
  assert_false(world.road_surface_contains94(animal.global_position,18.),"world spawn off road: "+animal.name)
 for script in [Horse,Pig,Goat]:
  var animal=_spawn(world,script,Vector2.ZERO)
  _check_motion(world,animal,Vector2.ZERO)
  animal.free()
 world.player.position=Vector2.ZERO;world.player.velocity=Vector2(100,0);world.player.gait=WorldGait.GALOPE
 world._stamina={"value":50.,"max":100.,"forced_left":0.};world._tick_stamina(1.)
 assert_almost_eq(float(world._stamina.value),50.-4.*WorldStamina.ROAD_DRAIN_MULT,.001)
