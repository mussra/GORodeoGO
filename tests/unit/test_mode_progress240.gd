extends GutTest
func test_victory_facts_and_duplicates():
 var state:=ModeVictories240.fresh()
 assert_true(ModeVictories240.record(state,"race",1,0))
 assert_false(ModeVictories240.record(state,"race",1,0))
 assert_false(ModeVictories240.record(state,"unknown",2))
 assert_false(ModeVictories240.record(state,"race",2,5))
 assert_true(ModeVictories240.record(state,"joust",2))
 assert_eq(state.wins,{"race":1,"joust":1})
 assert_eq(state.courses,{"0":1})
 assert_true(ModeVictories240.valid(str_to_var(var_to_str(state))))
func test_corrupt_history_is_not_accepted():
 for value in [{},{"version":2,"last":0,"wins":{},"courses":{}},{"version":1,"last":0,"wins":{"race":-1},"courses":{}},{"version":1,"last":0,"wins":{"bogus":1},"courses":{}},{"version":1,"last":0,"wins":{},"courses":{"9":1}}]:assert_false(ModeVictories240.valid(value))
func test_chain_from_empty_to_every_mode():
 var places:Dictionary={"visited":{"ranch":true,"home":true}}
 var quests:Dictionary={}
 var wins:Dictionary={}
 for mode in ModeVictories240.MODES:assert_false(ModeAccess240.open(mode,0,places,quests,false,wins))
 quests.farmer_pigs={"status":"done"}
 assert_true(ModeAccess240.rodeo_offered(quests))
 assert_false(ModeAccess240.open("bulls",0,places,quests,false,wins))
 assert_true(ModeAccess240.open("bulls",0,places,quests,true,wins))
 assert_false(ModeAccess240.open("race",1,places,quests,true,wins))
 places.visited.town1=true;places.visited.town2=true
 assert_eq(ModeAccess240.village_count(places),2)
 assert_true(ModeAccess240.open("race",1,places,quests,true,wins))
 assert_false(ModeAccess240.open("duel",1,places,quests,true,wins))
 wins.race=1;assert_false(ModeAccess240.open("duel",1,places,quests,true,wins))
 wins.race=2;assert_true(ModeAccess240.open("duel",1,places,quests,true,wins))
 assert_false(ModeAccess240.open("joust",1,places,quests,true,wins))
 wins.duel=1;assert_true(ModeAccess240.open("joust",1,places,quests,true,wins));assert_true(ModeAccess240.open("cup",1,places,quests,true,wins))
 assert_false(ModeAccess240.open("memory",1,places,quests,true,wins))
 wins.joust=1
 for mode in ModeVictories240.MODES:assert_true(ModeAccess240.open(mode,1,places,quests,true,wins))
func test_debug_opens_all_without_faking_wins():
 for mode in ModeVictories240.MODES:assert_true(ModeAccess240.open(mode,0,{},{},false,{},true))
func test_real_v6_village_visits_survive_reload_and_open_races()->void:
 var old:int=SaveData.world_generator_version
 SaveData.world_generator_version=6
 for seed_value in [123,87123]:
  var cousins:=VillageCousins140.fresh(seed_value,[],{})
  var places:=WorldPlaces144.fresh(seed_value,6)
  var sites:=WorldPlaces144.sites(seed_value,6,cousins)
  var visited:int=0
  for site in sites:
   if site.id in ["home","ranch"]:continue
   assert_true(WorldPlaces144.visit(places,site.pos,[site]))
   visited+=1
   if visited==2:break
  var restored:=WorldPlaces144.clean(places,seed_value,6)
  assert_eq(ModeAccess240.village_count(restored),2)
  assert_true(ModeAccess240.open("race",1,restored,{},true,{}))
 SaveData.world_generator_version=old
