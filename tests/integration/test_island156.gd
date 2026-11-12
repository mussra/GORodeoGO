extends GutTest
var world:CountryPreview146
func after_each():
 if is_instance_valid(world):world.free()
 await get_tree().process_frame
func test_closed_coast_keeps_existing_sites_and_both_directions_walkable():
 for seed_ in [1,123,752026,999999]:
  var data:=CountryRoute146.plan(seed_);assert_eq(data.island.size(),128);assert_true(CountryRoute146.path_clear(data,data.approach));assert_true(CountryRoute146.path_clear(data,data.upstream))
  for point in data.sites.values():assert_false(CountryIsland156.blocked(data.island,point,18.))
  for point in [Vector2(0,7000),Vector2(12500,7000),Vector2(6200,0),Vector2(6200,14000)]:assert_true(CountryRoute146.blocked(data,point))
func test_sea_collision_stops_all_four_cardinal_exits():
 world=CountryPreview146.new();add_child(world);world.player.set_physics_process(false);await get_tree().physics_frame
 for row in [[Vector2(1000,7000),Vector2(-2000,0)],[Vector2(11500,7000),Vector2(2000,0)],[Vector2(6200,1000),Vector2(0,-2000)],[Vector2(6200,13000),Vector2(0,2000)]]:
  world.player.position=row[0];var hit:=world.player.move_and_collide(row[1]);assert_not_null(hit);assert_false(CountryIsland156.blocked(world.data.island,world.player.position,0.))
func test_previous_rectangular_edge_save_can_recover_on_land_before_activation():
 world=CountryPreview146.new();add_child(world);world.player.set_physics_process(false);await get_tree().physics_frame
 var old:=Vector2(150,13500);world.player.position=old;assert_true(CountryRoute146.blocked(world.data,old));var recovered:=world.landing155(old);assert_true(recovered.is_finite());assert_false(CountryRoute146.blocked(world.data,recovered))
