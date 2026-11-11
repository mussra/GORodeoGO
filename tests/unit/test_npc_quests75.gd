extends GutTest
func test_pigs_require_acceptance_and_do_not_retrocount():
 var states={}
 assert_false(NpcQuests.can_capture(states,"pig"))
 assert_true(NpcQuests.record(states,"capture_animal","pig","old").is_empty())
 assert_true(NpcQuests.accept(states,"farmer_pigs"));assert_false(NpcQuests.accept(states,"farmer_pigs"))
 assert_true(NpcQuests.can_capture(states,"pig"));assert_eq(states.farmer_pigs.count,0)
 NpcQuests.record(states,"capture_animal","pig","one");NpcQuests.record(states,"capture_animal","pig","one")
 assert_eq(states.farmer_pigs.count,1)
 NpcQuests.record(states,"capture_animal","goat","wrong");assert_eq(states.farmer_pigs.count,1)
 for id in ["two","three"]:NpcQuests.record(states,"capture_animal","pig",id)
 assert_eq(states.farmer_pigs.status,"done");assert_true(NpcQuests.can_capture(states,"pig"))
func test_goats_follow_pigs_same_engine_and_remain_locked_until_accepted():
 var states={};assert_false(NpcQuests.accept(states,"farmer_goats"))
 NpcQuests.accept(states,"farmer_pigs")
 for id in ["one","two","three"]:NpcQuests.record(states,"capture_animal","pig",id)
 assert_eq(NpcQuests.next_for(states,NpcQuests.NPCS[0]),"farmer_pigs")
 NpcQuests.acknowledge(states,"farmer_pigs")
 assert_eq(NpcQuests.next_for(states,NpcQuests.NPCS[0]),"farmer_goats")
 assert_false(NpcQuests.can_capture(states,"goat"));assert_true(NpcQuests.accept(states,"farmer_goats"))
 for id in ["g1","g2","g3"]:NpcQuests.record(states,"capture_animal","goat",id)
 assert_eq(states.farmer_goats.status,"done")
func test_flower_is_forced_by_east_condition_not_random_and_persists_once():
 var states={}
 assert_true(NpcQuests.activate_triggers(states,Vector2(15*1024,0)).is_empty())
 assert_true(NpcQuests.activate_triggers(states,Vector2(-16*1024,0)).is_empty())
 assert_true(NpcQuests.activate_triggers(states,Vector2(0,16*1024)).is_empty())
 assert_eq(NpcQuests.activate_triggers(states,Vector2(15*1024+1,350)).size(),1)
 var spawn=states.east_flower.spawn
 assert_true(NpcQuests.activate_triggers(states,Vector2(19*1024,0)).is_empty());assert_eq(states.east_flower.spawn,spawn)
 var restored=NpcQuests.clean(states);assert_eq(restored,states)
 NpcQuests.record(restored,"find_object","east_flower","story:east_flower");assert_eq(restored.east_flower.status,"done")
 assert_true(NpcQuests.activate_triggers(restored,Vector2(19*1024,0)).is_empty())
func test_directions_and_distance_are_data():
 assert_true(NpcQuests.trigger_matches({"axis":"west","chunks":2},Vector2(-3000,0)))
 assert_true(NpcQuests.trigger_matches({"axis":"north","chunks":2},Vector2(0,-3000)))
 assert_true(NpcQuests.trigger_matches({"axis":"distance","chunks":2},Vector2(2000,2000)))
 assert_false(NpcQuests.trigger_matches({"axis":"unknown","chunks":0},Vector2(3000,0)))
func test_save_load_roundtrip_legacy_defaults_and_invalid_states():
 var save=load("res://src/Application/save_data.gd").new();save.save_path="user://npc-quest75.cfg";save.world_quests={};save.horse_collection.seed_trial()
 NpcQuests.accept(save.world_quests,"farmer_pigs");NpcQuests.record(save.world_quests,"capture_animal","pig","one")
 assert_true(save.save_progress())
 var readback=load("res://src/Application/save_data.gd").new();readback.save_path=save.save_path;readback.load_progress()
 assert_eq(readback.world_quests,save.world_quests);assert_eq(readback.world_quests.farmer_pigs.count,1)
 assert_true(NpcQuests.clean(null).is_empty());assert_true(NpcQuests.clean({"farmer_pigs":{"status":"done","count":99,"events":[]}}).farmer_pigs.status=="active")
 save.free();readback.free()
func test_completion_hud_thanks_once_and_persist_without_reset_to_zero():
 var states={};NpcQuests.accept(states,"farmer_pigs")
 for event in ["one","two","three"]:NpcQuests.record(states,"capture_animal","pig",event)
 var hud=NpcQuests.hud_text(states);assert_true(hud.contains("3/3"));assert_false(hud.contains("0/3"))
 assert_eq(NpcQuests.next_for(states,NpcQuests.NPCS[0]),"farmer_pigs")
 assert_true(NpcQuests.acknowledge(states,"farmer_pigs"));assert_false(NpcQuests.acknowledge(states,"farmer_pigs"))
 var restored=NpcQuests.clean(states);assert_true(restored.farmer_pigs.thanked);assert_eq(restored.farmer_pigs.count,3)
 assert_eq(NpcQuests.next_for(restored,NpcQuests.NPCS[0]),"farmer_goats")
