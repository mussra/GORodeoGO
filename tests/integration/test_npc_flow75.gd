extends GutTest
func test_live_world_capture_gates_dialog_save_sequence_and_flower():
 var previous:Dictionary={"quests":SaveData.world_quests,"trial":SaveData.trial_session_active,"position":SaveData.world_position}
 SaveData.trial_session_active=true;SaveData.world_quests={};SaveData.world_position=Vector2(310,270);SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child_autofree(world)
 while world._loading_world:await wait_process_frames(1)
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var pig=world.PigScript.new();pig.setup({"pos":Vector2(310,270)});world.add_child(pig)
 world._on_lasso_prey_captured(pig);assert_null(world._lasso_horse);assert_false(pig.roped)
 world.player.position=Vector2(310,270);world._open_npc(NpcQuests.NPCS[0]);assert_not_null(world._npc_dialog)
 assert_false(world.player.is_physics_processing())
 world._npc_dialog.accepted.emit("farmer_pigs");await wait_process_frames(1)
 assert_eq(SaveData.world_quests.farmer_pigs.status,"active");assert_null(world._npc_dialog)
 world._on_lasso_prey_captured(pig);assert_eq(world._lasso_horse,pig);assert_true(pig.roped);world._end_lasso();pig.queue_free()
 for event in ["one","two","three"]:world._quest_event("capture_animal","pig",event)
 NpcQuests.acknowledge(SaveData.world_quests,"farmer_pigs")
 world._open_npc(NpcQuests.NPCS[0]);world._npc_dialog.accepted.emit("farmer_goats");await wait_process_frames(1)
 assert_eq(SaveData.world_quests.farmer_goats.status,"active")
 var goats=world._prototype_goats.get_children();assert_eq(goats.size(),3)
 for goat in goats:
  goat.state.progress=1.0;goat.state.tired=true;goat.roped=true;goat.position=world.player.position+Vector2(160,0)
 world._tick_goats(.01);await wait_process_frames(1)
 assert_eq(SaveData.world_quests.farmer_goats.status,"done");assert_eq(SaveData.world_quests.farmer_goats.count,3)
 world.player.position=Vector2(15*1024,0);world._tick_npcs();assert_false(world._story_flower.visible)
 world.player.position.x+=1;world._tick_npcs();assert_true(world._story_flower.visible);assert_true(world._flower_button.visible)
 var spawn:Vector2=SaveData.world_quests.east_flower.spawn
 world.player.position=Vector2.ZERO;world._collect_story_flower();assert_eq(SaveData.world_quests.east_flower.count,0)
 world.player.position=spawn;world._collect_story_flower();world._tick_npcs()
 assert_eq(SaveData.world_quests.east_flower.status,"done");assert_false(world._story_flower.visible)
 SaveData.world_quests=previous.quests;SaveData.trial_session_active=previous.trial;SaveData.world_position=previous.position
