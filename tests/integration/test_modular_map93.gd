extends GutTest
func test_isolated_map_uses_clear_doorways_and_does_not_write_save():
 SaveData.save_path="user://modular93-regression-only.dat";SaveData.horse_collection.seed_trial()
 var before_edits=SaveData.world_edits.duplicate(true);var before_position=SaveData.world_position
 var before_exists=FileAccess.file_exists(SaveData.save_path)
 var map=load("res://src/Presentation/modular_world93.tscn").instantiate();add_child_autofree(map)
 await get_tree().process_frame
 map.player.set_physics_process(false)
 assert_eq(SaveData.world_edits,before_edits);assert_eq(SaveData.world_position,before_position)
 assert_eq(FileAccess.file_exists(SaveData.save_path),before_exists)
 for id in ModularWorldLayout93.DOORS:
  var door=ModularWorldLayout93.world(ModularWorldLayout93.DOORS[id])
  for box in map.collision_rects:assert_false(box.grow(8).has_point(door),id+" doorway remains clear")
 assert_eq(map.player.lasso.prey_provider.call().size(),2)
 assert_true(is_instance_valid(map.aim_joystick));assert_true(map.has_node("TouchControls/MoveJoystick"))
 map.dark=true;map._reload_art();map.ground.queue_redraw();map.roads.queue_redraw()
 await get_tree().process_frame
 assert_eq(SaveData.world_edits,before_edits);assert_eq(SaveData.world_position,before_position)

func test_door_approach_clear_but_building_body_blocks_rider():
 SaveData.horse_collection.seed_trial()
 var map=load("res://src/Presentation/modular_world93.tscn").instantiate();add_child_autofree(map)
 map.player.set_physics_process(false)
 await get_tree().physics_frame
 for id in ModularWorldLayout93.DOORS:
  var door=ModularWorldLayout93.world(ModularWorldLayout93.DOORS[id])
  map.player.position=door+Vector2(0,30)
  var clear=map.player.move_and_collide(Vector2(0,-28))
  assert_null(clear,id+" approach to threshold clear")
  var stop=map.player.move_and_collide(Vector2(0,-100))
  assert_not_null(stop,id+" solid body blocks beyond threshold")
