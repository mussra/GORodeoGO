extends GutTest
func test_buildings_do_not_cover_any_road_and_landmarks_visible():
 SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/modular_world93.tscn").instantiate();add_child_autofree(world)
 world.set_physics_process(false);world.player.set_physics_process(false)
 for seed in range(256):
  var g=ModularWorldLayout93.graph(seed)
  for cell in g:
   for next in g[cell]:
    for i in 5:
     var point:Vector2=ModularWorldLayout93.world(cell).lerp(ModularWorldLayout93.world(next),i/4.)
     for box in world.collision_rects:assert_false(box.grow(9).has_point(point),"building body clears road and rider for seed "+str(seed))
 for id in ModularWorldLayout93.LANDMARKS:assert_true(world.has_node("Landmark_"+id))
 for dark in [false,true]:
  world.dark=dark;world._reload_art()
  for id in ModularWorldLayout93.LANDMARKS:
   assert_true(world.road_surface_contains94(ModularWorldLayout93.world(ModularWorldLayout93.LANDMARKS[id])))
