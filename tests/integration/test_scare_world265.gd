extends "res://tests/integration/test_breeding_world256.gd"
func test_whip_captures_only_already_roped_goat_and_persists_once():
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_position=Vector2(1900,1000)
 SaveData.world_quests={"farmer_pigs":{"status":"done","count":3,"events":["a","b","c"]},"farmer_goats":{"status":"active","count":0,"events":[]}}
 SaveData.equipment_owned.append("scare_whip265");SaveData.equipment_equipped.scare_whip="scare_whip265"
 await launch()
 var goat=load("res://src/Presentation/wild_goat.gd").new();goat.setup({"pos":world.player.position+Vector2(150,0)});goat.set_meta("capture_id112","goat:265-test");world._prototype_goats.add_child(goat);await wait_frames(2)
 var before_points:int=SaveData.equipment_points
 assert_false(world.capture_goat265(goat));assert_false(SaveData.world_goat_captures.has("goat:265-test"))
 goat.roped=true;assert_true(goat.scare265(world.player.global_position,1.1));assert_true(SaveData.world_goat_captures.has("goat:265-test"));assert_gt(SaveData.equipment_points,before_points)
 assert_false(world.capture_goat265(goat));var gained:int=SaveData.equipment_points
 SaveData.load_progress();assert_true(SaveData.world_goat_captures.has("goat:265-test"));assert_eq(SaveData.equipment_points,gained)
