extends Node
func _ready():run.call_deferred()
func run():
 SaveData.save_path="user://measure219.cfg";SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.country_ledger146={};SaveData.world_cousins140=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]));SaveData.world_herd_town217=HerdTown217.fresh(752026,SaveData.world_cousins140,[],{},[])
 var base:Dictionary={"pos":SaveData.world_cousins140.doors.home,"traits":{"coat":0,"pattern":0,"mane":0,"eyes":0,"finish":"normal"},"stats":{"speed":280.}}
 var rows:Array=HerdTown217.colored(WorldHerd.members(base,752026,4,0,false),SaveData.world_herd_town217,4,0).map(func(h):return h.traits.duplicate(true))
 for count in [0,10,100,1000]:
  SaveData.world_herd_town217.herds={}
  for i in count:SaveData.world_herd_town217.herds[str(i)+",0"]=rows.duplicate(true)
  var samples:Array=[]
  for repeat_ in 7:
   var t:=Time.get_ticks_usec();var ok:=SaveData.save_progress();samples.append(float(Time.get_ticks_usec()-t)/1000.)
   if not ok:push_error("benchmark save failed")
  samples.sort();var file:=FileAccess.open(SaveData.save_path,FileAccess.READ)
  print("SAVE219 herds=",count," bytes=",file.get_length()," median_ms=",samples[3]," max_ms=",samples[-1]);file.close()
 DirAccess.remove_absolute(SaveData.save_path);get_tree().quit()
