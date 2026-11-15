extends GutTest
var saved:Dictionary={}
var collection:Dictionary={}
var world:Node2D
const ORIGIN:=Vector2i(2,1)
func before_each():
 for property in SaveData.get_script().get_script_property_list():
  var value:Variant=SaveData.get(property.name);saved[property.name]=value.duplicate(true) if value is Dictionary or value is Array else value
 collection=SaveData.horse_collection.export_state().duplicate(true)
 SaveData.save_path="user://herd226-world-test.cfg";SaveData._load_valid=true;SaveData.world_seed=7781;SaveData.world_generator_version=3;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 SaveData.world_flora138=FloristJourney138.fresh([]);SaveData.world_cousins140=VillageCousins140.fresh(7781,[],SaveData.world_flora138);SaveData.world_discovered=["2,1"];SaveData.world_quests={};SaveData.world_missions={};SaveData.world_roaming139={}
 SaveData.world_herd_town217={"version":1,"seed":7781,"towns":SaveData.world_cousins140.duplicate(true),"excluded":{"2,1":true},"herds":{}}
 SaveData.world_tamed=[WorldHerd.member_id(2,1,0)]
func after_each():
 if is_instance_valid(world):world.free()
 DirAccess.remove_absolute(SaveData.save_path)
 for key in saved:SaveData.set(key,saved[key])
 SaveData.horse_collection.restore(collection);await wait_process_frames(2)
func launch():
 world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 while world._loading_world:await wait_process_frames(1)
 await wait_seconds(.3);world.set_process(false);world.set_physics_process(false)
func test_discovered_legacy_herd_is_updated_on_world_load_without_respawning_captured_sibling():
 var base:Dictionary=WorldMap.generate(7781,2,1).get("herd",{});assert_false(base.is_empty());SaveData.world_position=base.pos
 var before_collection:=SaveData.horse_collection.export_state().duplicate(true);var towns:=SaveData.world_cousins140.duplicate(true);await launch()
 assert_eq(SaveData.world_herd_town217.version,2);assert_true(SaveData.world_herd_town217.revised226.has("2,1"));assert_eq(SaveData.horse_collection.export_state(),before_collection);assert_eq(SaveData.world_cousins140.doors,towns.doors)
 assert_false(world._herd_horses.has(WorldHerdPositions139.live_key(ORIGIN,0)))
 var checked:int=0
 for i in range(1,WorldHerd.members(base,7781,2,1,false).size()):
  var horse=world._herd_horses.get(WorldHerdPositions139.live_key(ORIGIN,i));assert_not_null(horse)
  if horse==null:continue
  var look:=TownIdentity215.look(SaveData.world_cousins140,TownIdentity215.nearest(SaveData.world_cousins140,horse.herd.pos))
  assert_true(horse.herd.traits.coat==look.coat or horse.herd.traits.pattern==look.pattern);checked+=1
 assert_gt(checked,0)
func test_roaming_horse_prepares_origin_even_when_its_origin_chunk_is_not_loaded():
 var pos:=Vector2(20000,300);var id:=WorldHerd.member_id(2,1,1);SaveData.world_position=pos
 SaveData.world_roaming139={"version":1,"seed":7781,"horses":{id:{"origin":ORIGIN,"index":1,"pos":pos}}}
 await launch()
 # Isolate the resume call from legitimate roaming physics after loading.
 var live_key:String=WorldHerdPositions139.live_key(ORIGIN,1)
 if world._herd_horses.has(live_key):world._herd_horses[live_key].queue_free()
 SaveData.world_roaming139={"version":1,"seed":7781,"horses":{id:{"origin":ORIGIN,"index":1,"pos":pos}}};world._roaming139.setup(SaveData.world_roaming139,7781)
 SaveData.world_herd_town217.revised226.erase("2,1")
 world._resume_roaming139()
 assert_false(world._chunks.has("2,1"));assert_true(SaveData.world_herd_town217.revised226.has("2,1"))
 var horse=world._herd_horses.get(WorldHerdPositions139.live_key(ORIGIN,1));assert_not_null(horse)
 if horse!=null:
  assert_eq(horse.home,pos);assert_eq(SaveData.world_roaming139.horses[id].pos,pos);assert_eq(horse.herd.member_id,id)
  var look:=TownIdentity215.look(SaveData.world_cousins140,"home");assert_true(horse.herd.traits.coat==look.coat or horse.herd.traits.pattern==look.pattern)
 assert_eq(SaveData.world_tamed,[WorldHerd.member_id(2,1,0)])
