extends "res://tests/integration/test_herd_migration226.gd"
func test_v6_recommendation_roundtrip_and_multiple_offices_per_town():
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_garden212=Garden212.fresh();SaveData.world_position=WorldNominal98.home()
 await launch();var seed_:int=SaveData.world_seed;var nodes:=TownNetwork234.nodes(seed_)
 assert_eq(SaveData.world_cousins140.doors.size(),nodes.size());assert_true(SaveData.world_cousins140.doors.has("town1"))
 var entries:Array=world._npcs98();assert_eq(entries.filter(func(n):return n.town234=="home").size(),4)
 var data:Dictionary=entries.filter(func(n):return n.town234=="home" and n.role234=="loco")[0];world.player.position=data.position
 finish_office249(data);world._open_npc(data);assert_eq(SaveData.world_cousins140.heard247.get("home|loco"),"direct");assert_true(world._npc_dialog is TownDialog234);var target:String=nodes.home.targets.loco
 world._npc_dialog.recommend_requested.emit(target);assert_null(world._npc_dialog);assert_true(world.player.is_physics_processing());assert_true(SaveData.world_cousins140.revealed215.has(target))
 SaveData.load_progress();assert_true(SaveData._load_valid);assert_eq(SaveData.world_generator_version,6);assert_true(SaveData.world_cousins140.revealed215.has(target));assert_eq(SaveData.world_cousins140.heard247.get("home|loco"),"direct");assert_eq(SaveData.world_cousins140.doors.size(),nodes.size())
 SaveData.debug_mode=false;world._open_network234();assert_null(world._npc_dialog)
 SaveData.debug_mode=true;world._open_network234();assert_true(world._npc_dialog is TownMap234);assert_true(world._npc_dialog.show_all);world._npc_dialog.closed.emit();assert_true(world.player.is_physics_processing());SaveData.debug_mode=false

func test_far_village_discovery_persists_after_focus_moves_and_mount_speed_energy_change():
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_garden212=Garden212.fresh();SaveData.world_position=WorldNominal98.home()
 await launch();var seed_:int=SaveData.world_seed
 var far:=TownNetwork234.cell_node(seed_,Vector2i(30,40));TownNetwork234.ensure_near(seed_,far.door);world.player.position=far.door
 var layer:TownLayer234
 for child in world.get_children():
  if child is TownLayer234:layer=child
 assert_not_null(layer);layer._process(0.);assert_true(layer.built.has(far.id));assert_true(SaveData.world_cousins140.known.has(far.id))
 TownNetwork234.ensure_near(seed_,Vector2.ZERO);assert_true(SaveData.save_progress());SaveData.load_progress();assert_true(SaveData._load_valid);assert_eq(SaveData.world_cousins140.doors[far.id],far.door);assert_true(SaveData.world_cousins140.known.has(far.id))
 SaveData.horse_collection.add_trial_parents();SaveData.horse_collection.find("trial_a").stats={"speed":240.,"power":.5};SaveData.horse_collection.find("trial_b").stats={"speed":300.,"power":.9}
 SaveData.horse_collection.selected="trial_a";world._sync_mount237();assert_eq(world.player.max_speed,240.);world._stamina.value=22.
 SaveData.horse_collection.selected="trial_b";world._sync_mount237();assert_eq(world.player.max_speed,300.);assert_gt(world._stamina.max,100.)
 SaveData.horse_collection.selected="trial_a";world._sync_mount237();assert_eq(world.player.max_speed,240.);assert_eq(world._stamina.value,22.,"Switching horses cannot refill the first one's stamina")

func test_terminal_recommends_a_real_pending_office_without_relaying_its_job():
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_garden212=Garden212.fresh();SaveData.world_position=WorldNominal98.home()
 await launch()
 var choice:Dictionary={}
 for entry in world._npcs98():
  if not TownNetwork234.node_for(SaveData.world_seed,entry.town234).targets.has(entry.role234):choice=entry;break
 assert_false(choice.is_empty())
 world.player.position=choice.position;finish_office249(choice);world._open_npc(choice)
 var convo:Dictionary=world._npc_dialog.conversation247
 assert_true(convo.relayed.is_empty());assert_false(convo.target.is_empty());assert_false(convo.complete)
 var key_:String=TownMessages247.key(choice.town234,choice.role234)
 assert_eq(SaveData.world_cousins140.heard247[key_],'direct')
 world._close_npc();SaveData.load_progress();assert_eq(SaveData.world_cousins140.heard247[key_],'direct')
 var before:Dictionary=SaveData.world_cousins140.duplicate(true);var model:=TownMessages247.open(SaveData.world_seed,before,choice.town234,choice.role234)
 SaveData._load_valid=false;assert_false(SaveData.commit_cousins140(model.state,world.player.position));assert_eq(SaveData.world_cousins140,before);SaveData._load_valid=true

func finish_office249(data:Dictionary)->void:
 SaveData.world_jobs249[TownJobs249.key(data.town234,data.role234)]={"status":"done","count":1,"events":["test249"],"thanked":true}
