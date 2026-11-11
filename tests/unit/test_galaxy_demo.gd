extends GutTest
func test_demo_steps_do_not_modify_collection_or_training():
 var before=SaveData.horse_collection.export_state();var quests=SaveData.world_quests.duplicate(true);var points=SaveData.equipment_points
 var demo=load("res://tools/demo_galaxy.tscn").instantiate();add_child_autofree(demo)
 for stage in 4:
  demo.stage=stage;demo.build();await wait_process_frames(2)
  assert_gt(demo.canvas.get_child_count(),10)
  assert_eq(SaveData.horse_collection.export_state(),before);assert_eq(SaveData.world_quests,quests);assert_eq(SaveData.equipment_points,points)
 assert_eq(demo.STEPS.size(),4)
