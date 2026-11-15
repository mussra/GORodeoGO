extends "res://tests/unit/test_herd_town217.gd"
func sample226(point:Vector2)->Dictionary:
 return {"pos":point,"traits":{"coat":0,"pattern":2,"mane":0,"eyes":0,"finish":"normal"},"temperament":.8,"stats":{"speed":280.,"power":.7,"handling":1000.}}
func isolated226(seed_:int)->Dictionary:
 var towns:=VillageCousins140.fresh(seed_,[],FloristJourney138.fresh([]))
 for id in towns.doors:towns.doors[id]=Vector2(100000,100000)
 towns.doors.home=Vector2.ZERO
 return towns
func test_every_horse_near_each_town_has_at_least_one_trait_including_outer_radius():
 var count:int=0;var coats:Dictionary={};var patterns:Dictionary={}
 for seed_ in range(7781,7791):
  var towns:=VillageCousins140.fresh(seed_,[],FloristJourney138.fresh([]));var state:=HerdTown217.fresh(seed_,towns,[],{},[])
  for id in VillageCousins140.IDS:
   for distance in [0.,500.,1000.,2200.,2850.]:
    var point:Vector2=towns.doors[id]+Vector2(0,distance)
    var before:=WorldHerd.members(sample226(point),seed_,distance/100,2,false);var after:=HerdTown217.colored(before,state,distance/100,2)
    assert_eq(after,HerdTown217.colored(before,state,distance/100,2),"Stable draws")
    for i in after.size():
     var horse:Dictionary=after[i];var family:=HerdTown217.influence(towns,horse.pos)
     if family.total<=0.:assert_eq(horse,before[i]);continue
     var look:=TownIdentity215.look(towns,TownIdentity215.nearest(towns,horse.pos))
     assert_true(horse.traits.coat==look.coat or horse.traits.pattern==look.pattern,"Every local wild horse must carry coat OR pattern")
     assert_eq(horse.pos,before[i].pos);assert_eq(horse.stats,before[i].stats);assert_eq(horse.temperament,before[i].temperament);assert_eq(horse.member_id,before[i].member_id)
     assert_ne(horse.traits.coat,horse.traits.spots);count+=1;coats[horse.traits.coat]=true;patterns[horse.traits.pattern]=true
 assert_gt(count,600);assert_gt(coats.size(),5);assert_gt(patterns.size(),2)
func test_overlap_matches_nearest_town_not_a_random_neighbour():
 var towns:=isolated226(7781);towns.doors.east138=Vector2(2000,0)
 for cx in range(20):
  var before:=WorldHerd.members(sample226(Vector2(400,0)),7781,cx,0,false)
  var after:=HerdTown217.colored(before,HerdTown217.fresh(7781,towns,[],{},[]),cx,0)
  var look:=TownIdentity215.look(towns,"home")
  for horse in after:assert_true(horse.traits.coat==look.coat or horse.traits.pattern==look.pattern)
func test_partial_capture_is_immutable_but_wild_siblings_are_updated():
 var towns:=isolated226(7781);var state:=HerdTown217.fresh(7781,towns,["1,0"],{},["herd_1,0#0"])
 var before:=WorldHerd.members(sample226(Vector2.ZERO),7781,1,0,false);var captured:Array=[before[0].member_id]
 var after:=HerdTown217.colored(before,state,1,0,captured);assert_eq(after[0],before[0])
 var look:=TownIdentity215.look(towns,"home")
 for i in range(1,after.size()):assert_true(after[i].traits.coat==look.coat or after[i].traits.pattern==look.pattern)
 assert_eq(HerdTown217.colored(before,state,1,0,[WorldMap.herd_mission_id(1,0)]),before)
func test_old_saved_policy_migrates_once_atomic_and_keeps_collection_ids_and_positions():
 SaveData.save_path="user://herd226-migration.cfg";SaveData._load_valid=true;SaveData.world_seed=7781;SaveData.world_generator_version=3
 SaveData.world_cousins140=isolated226(7781);SaveData.world_tamed=["herd_1,0#0"];SaveData.world_discovered=["1,0"]
 SaveData.world_roaming139={"version":1,"horses":{}}
 var base:=sample226(Vector2.ZERO);var original:=WorldHerd.members(base,7781,1,0,false);var traits:Array=original.map(func(h):return h.traits.duplicate(true))
 SaveData.world_herd_town217={"version":1,"seed":7781,"towns":SaveData.world_cousins140.duplicate(true),"excluded":{"1,0":true},"herds":{"1,0":traits.duplicate(true)}}
 var prior:=SaveData.world_herd_town217.duplicate(true);var collection:=SaveData.horse_collection.export_state().duplicate(true);var towns:=SaveData.world_cousins140.duplicate(true);var positions:=SaveData.world_roaming139.duplicate(true)
 assert_true(HerdTown217.valid(prior,7781));SaveData._load_valid=false;assert_false(SaveData.ensure_herd_town217());assert_eq(SaveData.world_herd_town217,prior)
 SaveData._load_valid=true;assert_true(SaveData.ensure_herd_town217());assert_eq(SaveData.world_herd_town217.version,2);assert_true(HerdTown217.eligible(SaveData.world_herd_town217,1,0))
 var migrated:=SaveData.world_herd_town217.duplicate(true);SaveData._load_valid=false;assert_false(SaveData.prepare_herd217(base,1,0));assert_eq(SaveData.world_herd_town217,migrated)
 SaveData._load_valid=true;assert_true(SaveData.prepare_herd217(base,1,0));assert_eq(SaveData.world_herd_town217.herds["1,0"][0],traits[0])
 var look:=TownIdentity215.look(SaveData.world_cousins140,"home")
 for i in range(1,traits.size()):
  var horse:Dictionary=SaveData.world_herd_town217.herds["1,0"][i];assert_true(horse.coat==look.coat or horse.pattern==look.pattern)
 var once:=SaveData.world_herd_town217.duplicate(true);assert_true(SaveData.prepare_herd217(base,1,0));assert_eq(SaveData.world_herd_town217,once)
 assert_eq(SaveData.world_tamed,["herd_1,0#0"]);assert_eq(SaveData.horse_collection.export_state(),collection);assert_eq(SaveData.world_cousins140,towns);assert_eq(SaveData.world_roaming139,positions)
 SaveData.load_progress();assert_true(SaveData._load_valid);assert_eq(SaveData.world_herd_town217,once);assert_eq(SaveData.horse_collection.export_state(),collection)
 DirAccess.remove_absolute(SaveData.save_path)
func test_uniform_fallback_cannot_remove_only_town_trait():
 var towns:=isolated226(7781);var state:=HerdTown217.fresh(7781,towns,[],{},[]);var look:=TownIdentity215.look(towns,"home")
 for cx in range(250):
  var before:=WorldHerd.members(sample226(Vector2.ZERO),7781,cx,0,false);var after:=HerdTown217.colored(before,state,cx,0)
  var variations:Dictionary={}
  for horse in after:
   assert_true(horse.traits.coat==look.coat or horse.traits.pattern==look.pattern);variations[str([horse.traits.coat,horse.traits.pattern,horse.traits.spots])]=true
  assert_gt(variations.size(),1)
