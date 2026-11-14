extends GutTest
var saved219:Dictionary={}
var collection219:Dictionary={}
func snapshot219():
 saved219={}
 for property in SaveData.get_script().get_script_property_list():
  var value:Variant=SaveData.get(property.name)
  saved219[property.name]=value.duplicate(true) if value is Dictionary or value is Array else value
 collection219=SaveData.horse_collection.export_state().duplicate(true)
func restore219():
 for key in saved219:SaveData.set(key,saved219[key])
 SaveData.horse_collection.restore(collection219)
func before_each():snapshot219()
func after_each():restore219()
func test_new_policy_excludes_seen_roaming_and_captured_origins_and_keeps_stats():
 var towns:=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]))
 var state:=HerdTown217.fresh(752026,towns,["1,0"],{"horses":{"a":{"origin":Vector2i(2,0)}}},["herd_3,0#1"])
 for x in [1,2,3]:assert_false(HerdTown217.eligible(state,x,0))
 assert_true(HerdTown217.eligible(state,4,0));assert_true(HerdTown217.valid(state,752026))
 var base:Dictionary={"pos":towns.doors.home,"traits":{"coat":0,"pattern":0,"mane":0,"eyes":0,"finish":"normal"},"temperament":.8,"stats":{"speed":280.,"power":.7,"handling":1000.}}
 var before:=WorldHerd.members(base,752026,4,0,false);var after:=HerdTown217.colored(before,state,4,0)
 assert_eq(HerdTown217.colored(before,state,1,0),before)
 assert_eq(after,HerdTown217.colored(before,state,4,0));assert_eq(before.size(),after.size())
 var looks:Dictionary={}
 for i in after.size():
  assert_eq(before[i].stats,after[i].stats);assert_eq(before[i].temperament,after[i].temperament);assert_eq(before[i].pos,after[i].pos);assert_eq(before[i].member_id,after[i].member_id)
  looks[str([after[i].traits.coat,after[i].traits.pattern,after[i].traits.spots])]=true
 assert_gt(looks.size(),1)
 state.herds["4,0"]=after.map(func(h):return h.traits.duplicate(true))
 assert_eq(HerdTown217.apply_saved(before,state,4,0),after)
 var changed_towns:=state.duplicate(true);changed_towns.towns.towns215.home.coat=19
 assert_eq(HerdTown217.apply_saved(before,changed_towns,4,0),after)
func test_distance_blending_and_no_remote_changes():
 var towns:=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]))
 for id in towns.doors:towns.doors[id]=Vector2(100000,0)
 towns.doors.home=Vector2.ZERO;towns.doors.east138=Vector2(4000,0)
 var near:=HerdTown217.influence(towns,Vector2(500,0));assert_almost_eq(near.strength,1.,.001);assert_eq(near.rows.size(),1)
 var middle:=HerdTown217.influence(towns,Vector2(2000,0));assert_eq(middle.rows.size(),2);assert_almost_eq(middle.strength,.5,.001)
 assert_eq(HerdTown217.influence(towns,Vector2(0,5000)).rows.size(),0)
func test_visit_order_real_second_town_and_legacy_next_new_not_pin():
 var towns:=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]));var sites:=WorldPlaces144.sites(752026,3,towns)
 var places:=WorldPlaces144.fresh(752026,3)
 assert_true(WorldPlaces144.visit(places,sites[0].pos,sites));assert_eq(places.teach217,"")
 var clue:=TownIdentity215.hint(towns,"home");assert_eq(places.teach217,"")
 assert_true(WorldPlaces144.visit(places,sites[1].pos,sites));assert_eq(places.teach217,sites[1].id)
 var before:=places.duplicate(true);assert_false(WorldPlaces144.visit(places,sites[1].pos,sites));assert_eq(places,before)
 var old:Dictionary={"version":1,"seed":752026,"generator":3,"visited":{"ranch":true,"east138":true}}
 var legacy:=WorldPlaces144.clean(old,752026,3);assert_true(legacy.legacy_order217);assert_true(legacy.visit_order217.is_empty())
 assert_true(WorldPlaces144.visit(legacy,sites[2].pos,sites));assert_eq(legacy.teach217,sites[2].id)
 assert_eq(WorldPlaces144.clean(legacy,752026,3),legacy)
 assert_true(HerdTown217.explanation(towns,"home").contains("estrellas"));assert_true(HerdTown217.explanation(towns,"east138").contains("jirafa"))
func test_policy_save_is_atomic_future_version_blocks_load_and_collection_unchanged():
 var path:String=SaveData.save_path;var old:Dictionary=SaveData.world_herd_town217.duplicate(true);var seed_:int=SaveData.world_seed
 SaveData.save_path="user://herd217-unit.cfg";SaveData.world_seed=752026;SaveData._load_valid=true;SaveData.world_generator_version=3
 SaveData.world_cousins140=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]));SaveData.world_discovered=[];SaveData.world_roaming139={};SaveData.world_tamed=[];SaveData.world_herd_town217={}
 var collection:=SaveData.horse_collection.export_state().duplicate(true)
 assert_true(SaveData.ensure_herd_town217())
 var base:Dictionary={"pos":SaveData.world_cousins140.doors.home,"traits":{"coat":0,"pattern":0,"mane":0,"eyes":0,"finish":"normal"},"stats":{"speed":280.}}
 var before:=SaveData.world_herd_town217.duplicate(true);SaveData._load_valid=false;assert_false(SaveData.prepare_herd217(base,8,4));assert_eq(SaveData.world_herd_town217,before)
 SaveData._load_valid=true;assert_true(SaveData.prepare_herd217(base,8,4));var expected:=SaveData.world_herd_town217.duplicate(true)
 SaveData.load_progress();assert_eq(SaveData.world_herd_town217,expected);assert_eq(SaveData.horse_collection.export_state(),collection)
 var config:=ConfigFile.new();assert_eq(config.load(SaveData.save_path),OK);config.set_value("world","herd_town217",{"version":999});assert_eq(config.save(SaveData.save_path),OK)
 SaveData.load_progress();assert_false(SaveData._load_valid);assert_false(SaveData.save_progress())
 SaveData._load_valid=true;SaveData.world_seed=seed_;SaveData.world_herd_town217=old;DirAccess.remove_absolute(SaveData.save_path);SaveData.save_path=path
func test_distant_herds_do_not_write_unchanged_genetics_and_bad_eyes_are_rejected():
 SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData._load_valid=false
 var towns:=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]))
 SaveData.world_herd_town217=HerdTown217.fresh(752026,towns,[],{},[])
 var base:Dictionary={"pos":Vector2(0,100000),"traits":{"coat":0,"pattern":0,"mane":0,"eyes":0,"finish":"normal"}}
 assert_true(SaveData.prepare_herd217(base,0,100));assert_true(SaveData.world_herd_town217.herds.is_empty())
 var traits:Dictionary={"coat":0,"pattern":0,"mane":0,"eyes":0,"spots":1,"finish":"normal"}
 SaveData.world_herd_town217.herds["1,1"]=[traits.duplicate(true),traits.duplicate(true),traits.duplicate(true)]
 assert_true(HerdTown217.valid(SaveData.world_herd_town217,752026))
 SaveData.world_herd_town217.herds["1,1"][0].eyes=HorseCollection.EYES.size()
 assert_false(HerdTown217.valid(SaveData.world_herd_town217,752026))
