extends SceneTree
func _initialize():
 var start=Time.get_ticks_usec();var layouts={};var placements={};var content={};var collisions:int=0;var fingerprints={}
 for seed in range(1,100001):
  var plan=ModularWorldLayout93.plan(seed)
  var signature:String=str(plan.branches)
  layouts[signature]=int(layouts.get(signature,0))+1
  placements[str(plan.doors)]=true
  var generated=WorldMap.generate(seed,1,0)
  var fp:String=var_to_str(generated)
  content[fp]=true
  var mixed:int=hash("rancho-frontera-%d-%d-%d"%[seed,1,0])
  if fingerprints.has(mixed):collisions+=1
  fingerprints[mixed]=true
 print("SEEDS101 ",JSON.stringify({"samples":100000,"unique_road_layouts":layouts.size(),"frequencies":layouts.values(),"unique_building_placements":placements.size(),"unique_chunk_content":content.size(),"seed_hash_collisions_one_chunk":collisions,"elapsed_ms":(Time.get_ticks_usec()-start)/1000.}))
 quit()
