extends "res://tests/integration/test_herd_migration226.gd"
func prepare249():
 SaveData.world_generator_version=6;SaveData.world_jobs249={};SaveData.world_goats_given249=0;SaveData.world_pigs_sold=0;SaveData.world_pig_captures=[];SaveData.world_goat_captures=[];SaveData.world_quests={};SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_garden212=Garden212.fresh();SaveData.trial_session_active=false;SaveData.world_position=WorldNominal98.home()
func entry(role_:String,away:bool=true)->Dictionary:
 for data in world._npcs98():
  if data.role234==role_ and (data.town234!="home" if away else data.town234=="home"):return data
 return {}
func test_free_capture_without_a_quest_and_inventory_sale_once_in_same_save():
 prepare249()
 assert_true(SaveData.can_capture_animal165("pig"));assert_true(SaveData.can_capture_animal165("goat"))
 assert_true(SaveData.record_pig104("free-pig"));assert_true(SaveData.record_goat104("free-goat"))
 await launch();var data:=entry("farmer");var q:=TownJobs249.job(SaveData.world_seed,data.town234,"farmer")
 var n:int=TownJobs249.inventory(q.target);assert_eq(n,1)
 world.player.position=data.position;world._open_npc(data)
 var dialog:TownDialog234=world._npc_dialog
 assert_true(dialog.body247.text.contains("ya tienes"));assert_false(dialog.has_node("DestinationThumbnail248"));assert_eq(dialog.target247,"")
 var points:int=SaveData.equipment_points
 assert_true(SaveData.deliver_town_job249(data.town234,"farmer"));assert_eq(SaveData.equipment_points,points+40)
 assert_eq(TownJobs249.inventory(q.target),0);assert_false(SaveData.deliver_town_job249(data.town234,"farmer"))
 world._close_npc();SaveData.load_progress()
 assert_true(TownJobs249.delivered(data.town234,"farmer"));assert_eq(TownJobs249.inventory(q.target),0)
 world._open_npc(data);assert_true(world._npc_dialog.has_node("DestinationThumbnail248"))
func test_delivery_failure_restores_inventory_points_and_job_without_partial_reward():
 prepare249()
 await launch();var data:=entry("farmer");var q:=TownJobs249.job(SaveData.world_seed,data.town234,"farmer")
 SaveData.world_pig_captures=["p"];SaveData.world_goat_captures=["g"]
 var before:int=SaveData.equipment_points;SaveData._load_valid=false
 assert_false(SaveData.deliver_town_job249(data.town234,"farmer"));assert_eq(TownJobs249.inventory(q.target),1)
 assert_eq(SaveData.equipment_points,before);assert_eq(SaveData.world_jobs249,{})
 SaveData._load_valid=true
func test_florist_actual_targets_three_unique_pickups_return_then_recommendation():
 prepare249()
 await launch();var data:=entry("florist");world.player.position=data.position;world._open_npc(data)
 var dialog:TownDialog234=world._npc_dialog;assert_true(dialog.body247.text.contains("tres flores"));assert_eq(dialog.target247,"")
 var id:=TownJobs249.key(data.town234,"florist");var q:=TownJobs249.job(SaveData.world_seed,data.town234,"florist")
 dialog.job_action249.emit("accept");await wait_process_frames(2);world._close_npc()
 var points:=TownJobs249.positions(SaveData.world_seed,q);assert_eq(points.size(),3)
 for p in points:
  world.player.position=p;world._tick_jobs249();world._tick_jobs249()
 assert_eq(SaveData.world_jobs249[id].count,3);assert_eq(SaveData.world_jobs249[id].events.size(),3)
 assert_false(TownJobs249.delivered(data.town234,"florist"))
 var reward:int=SaveData.equipment_points
 assert_true(SaveData.deliver_town_job249(data.town234,"florist"));assert_eq(SaveData.equipment_points,reward+120)
 assert_false(SaveData.deliver_town_job249(data.town234,"florist"));SaveData.load_progress();assert_true(TownJobs249.delivered(data.town234,"florist"))
func test_saddler_counts_only_new_taming_after_accept_and_keeps_horse():
 prepare249()
 await launch();var data:=entry("saddler");var id:=TownJobs249.key(data.town234,"saddler");var q:=TownJobs249.job(SaveData.world_seed,data.town234,"saddler")
 assert_eq(TownJobs249.record("tame_horse","horse","old"),[])
 assert_true(NpcQuests.accept(SaveData.world_jobs249,id,{id:q}))
 var before:int=SaveData.horse_collection.horses.size()
 TownJobs249.record("tame_horse","horse","new");TownJobs249.record("tame_horse","horse","new")
 assert_eq(SaveData.world_jobs249[id].count,1);assert_false(TownJobs249.delivered(data.town234,"saddler"))
 assert_true(SaveData.deliver_town_job249(data.town234,"saddler"));assert_eq(SaveData.horse_collection.horses.size(),before)
func test_legacy_farmer_recognizes_existing_animals_but_does_not_reuse_sold_stock():
 prepare249()
 SaveData.world_pig_captures=["a","b","c"]
 var points:int=SaveData.equipment_points
 assert_true(SaveData.deliver_legacy_animals249("farmer_pigs"));assert_eq(SaveData.pig_inventory104(),0)
 assert_eq(SaveData.equipment_points,points+120);assert_false(SaveData.deliver_legacy_animals249("farmer_pigs"))
 assert_false(SaveData.deliver_legacy_animals249("farmer_goats"))
 SaveData.load_progress();assert_true(SaveData.world_quests.farmer_pigs.thanked);assert_eq(SaveData.pig_inventory104(),0)
func test_loco_objective_requires_real_arrival_and_return_not_just_opening_dialog():
 prepare249()
 await launch();var data:=entry("loco",false);var id:=TownJobs249.key(data.town234,"loco");var q:=TownJobs249.job(SaveData.world_seed,data.town234,"loco")
 world.player.position=data.position;world._open_npc(data);assert_false(world._npc_dialog.has_node("DestinationThumbnail248"))
 assert_false(SaveData.world_cousins140.get("heard247",{}).has(id));world._close_npc()
 NpcQuests.accept(SaveData.world_jobs249,id,{id:q});world.player.position=TownJobs249.positions(SaveData.world_seed,q)[0];world._tick_jobs249()
 assert_eq(SaveData.world_jobs249[id].status,"done");assert_false(TownJobs249.delivered(data.town234,"loco"))
 assert_true(SaveData.deliver_town_job249(data.town234,"loco"));assert_true(TownJobs249.delivered(data.town234,"loco"))
func test_clean_drops_unknown_office_and_duplicate_events_without_trusting_flags():
 prepare249()
 var q:=TownJobs249.job(SaveData.world_seed,"home","saddler")
 var raw:Dictionary={"home|saddler":{"status":"active","count":90,"events":["one","one"]},"bogus|farmer":{"status":"done","count":1,"events":["x"]}}
 var clean:=TownJobs249.clean(raw,SaveData.world_seed)
 assert_eq(clean.size(),1);assert_eq(clean["home|saddler"].count,1)
 assert_eq(clean["home|saddler"].status,"done");assert_false(clean["home|saddler"].get("thanked",false))
