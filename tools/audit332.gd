extends Node
var results:Dictionary={"seed":3322026,"counts":{},"failures":[],"completed":false}
var rng:=RandomNumberGenerator.new()
func check332(ok:bool,category:String,case_:String):
 results.counts[category]=int(results.counts.get(category,0))+1
 if not ok:
  results.failures.append({"category":category,"case":case_})
  print('AUDIT332 FAIL ',category,' ',case_)
func round332(value:Variant)->Variant:return str_to_var(var_to_str(value))
func _ready():run332.call_deferred()
func run332():
 rng.seed=3322026
 for generator in range(1,7):
  SaveData.world_generator_version=generator
  for n in 48:
   var seed_:int=[1,7,20,752026,2147483647][n] if n<5 else rng.randi_range(1,2147483647)
   SaveData.world_seed=seed_;SaveData.world_herd_town217={}
   var flora=FloristJourney138.fresh([]);var towns=VillageCousins140.fresh(seed_,[],flora)
   var normalized=VillageCousins140.clean(round332(towns),seed_)
   check332(VillageCousins140.clean(round332(normalized),seed_)==normalized and TownIdentity215.clean(towns.towns215,seed_)==towns.towns215,'town_roundtrip','%s/%s'%[generator,seed_])
   var policy=HerdTown217.fresh(seed_,towns,[],{},[])
   for pos in [Vector2i(-2,-1),Vector2i(-1,1),Vector2i(1,-1),Vector2i(2,1),Vector2i(12,-9)]:
    var chunk=WorldMap.generate(seed_,pos.x,pos.y)
    check332(WorldMap.generate(seed_,pos.x,pos.y)==chunk,'chunk_determinism','%s/%s/%s'%[generator,seed_,pos])
    var base=chunk.get('herd',{})
    if base.is_empty():continue
    var members=HerdTown217.colored(WorldHerd.members(base,seed_,pos.x,pos.y,false),policy,pos.x,pos.y)
    var key=WorldMap.chunk_key(pos.x,pos.y);policy.herds[key]=members.map(func(h):return h.traits.duplicate(true));policy.revised226[key]=true
    var c=HorseCollection.new();c.seed_trial()
    for i in members.size():
     check332(c.valid_traits(members[i].traits),'wild_traits','%s/%s/%s/%s'%[generator,seed_,pos,i])
     var horse=members[i].duplicate(true);horse.id='wild_'+str(i);horse.name='Wild';horse.parents=[];c.horses.append(horse)
    var restored=HorseCollection.new();check332(restored.restore(round332(c.export_state())),'wild_collection','%s/%s/%s'%[generator,seed_,pos])
   check332(HerdTown217.valid(round332(policy),seed_),'herd_policy','%s/%s'%[generator,seed_])
   check332(CountryLedger146.valid(round332(CountryLedger146.fresh(seed_,generator)),seed_,generator),'country_fresh','%s/%s'%[generator,seed_])
   var ledger=CountryLedger146.fresh(seed_,generator)
   var entered=CountryLedger146.enter(ledger,Vector2(200,160),seed_)
   check332(not entered.is_empty() and CountryLedger146.valid(round332(entered),seed_,generator),'country_enter','%s/%s'%[generator,seed_])
   if not entered.is_empty():
    var route=CountryRoute146.plan(seed_);var moved=CountryLedger146.record_position(entered,route.entry)
    check332(not moved.is_empty() and CountryLedger146.valid(round332(moved),seed_,generator),'country_position','%s/%s'%[generator,seed_])
    var left=CountryLedger146.leave(moved,route.entry)
    check332(not left.is_empty() and CountryLedger146.valid(round332(left.state),seed_,generator),'country_leave','%s/%s'%[generator,seed_])
   if n<4:await save332(generator,seed_,flora,towns,policy)
   if n%8==0:await get_tree().process_frame
 var validator=HorseCollection.new()
 for coat in HorseCollection.COATS.size():
  for pattern in HorseCollection.PATTERNS.size():
   for mane in HorseCollection.MANES.size():
    for eyes in HorseCollection.EYES.size():check332(validator.valid_traits({'coat':coat,'pattern':pattern,'mane':mane,'eyes':eyes}),'palette_product','%s/%s/%s/%s'%[coat,pattern,mane,eyes])
 for key in ['coat','pattern','mane','eyes','spots','legs']:
  for value in [-200,-2,99,2147483647,'red',{},null]:
   var traits_={'coat':0,'pattern':0,'mane':0};traits_[key]=value
   check332(not validator.valid_traits(traits_),'invalid_traits',key+str(value))
 for key in ['spots','legs']:
  for index in range(-1,HorseCollection.COATS.size()):
   for style in ['flat','rainbow']:
    for finish in ['normal','original','galaxy']:
     var t={'coat':20,'pattern':17,'mane':5,'eyes':21,'finish':finish,'coat_style238':style,'spots_style238':style};t[key]=index
     check332(validator.valid_traits(t),'optional_appearance',key+str(index)+style+finish)
 for i in 2000:
  var c=HorseCollection.new();c.seed_trial();c.add_trial_parents()
  for h in c.horses:
   h.traits={"coat":rng.randi_range(0,HorseCollection.COATS.size()-1),"pattern":rng.randi_range(0,HorseCollection.PATTERNS.size()-1),"mane":rng.randi_range(0,HorseCollection.MANES.size()-1),"eyes":rng.randi_range(0,HorseCollection.EYES.size()-1),"spots":rng.randi_range(-1,HorseCollection.COATS.size()-1),"legs":rng.randi_range(-1,HorseCollection.COATS.size()-1),"finish":["normal","galaxy"][i%2]}
  var child=c.breed('trial_a','trial_b',{"coat":i%2,"pattern":(i/2)%2,"mane":(i/3)%2});c.mature_trial(child.id)
  var restored=HorseCollection.new();check332(restored.restore(round332(c.export_state())),'breeding_collection',str(i))
 for progress in range(1,61):
  var c=HorseCollection.new();c.seed_trial()
  for offer in HorseMarket.offers(progress):
   check332(c.valid_traits(offer.traits),'market_traits','%s/%s'%[progress,offer.offer_id]);HorseMarket.buy(c,offer)
  var restored=HorseCollection.new();check332(restored.restore(round332(c.export_state())),'market_collection',str(progress))
 var victories=ModeVictories240.fresh()
 for sequence in range(1,301):
  var mode=ModeVictories240.MODES[sequence%ModeVictories240.MODES.size()]
  check332(ModeVictories240.record(victories,mode,sequence,sequence%4) and ModeVictories240.valid(round332(victories)),'victories',str(sequence))
 var quests={}
 for id in NpcQuests.QUESTS:
  NpcQuests.accept(quests,id)
  var q=NpcQuests.QUESTS[id]
  for i in q.goal:
   NpcQuests.record(quests,q.kind,q.target,id+':'+str(i))
   check332(NpcQuests.clean(round332(quests))==quests,'quests',id+str(i))
 var contract=ProgressionEconomy165.new_contract()
 for cycle in 100:
  ProgressionEconomy165.accept(contract)
  var target=ProgressionEconomy165.target(contract)
  for i in ProgressionEconomy165.CONTRACT_GOAL:ProgressionEconomy165.record(contract,target,str(cycle)+':'+str(i))
  check332(ProgressionEconomy165.clean(round332(contract))==contract,'contract_ready',str(cycle))
  check332(ProgressionEconomy165.claim(contract)==ProgressionEconomy165.CONTRACT_REWARD and ProgressionEconomy165.clean(round332(contract))==contract,'contract_claim',str(cycle))
 var garden=Garden212.fresh()
 for action_ in ['introduce','accept','sample','plant','water']:
  garden=Garden212.action(garden,action_);check332(Garden212.clean(round332(garden))==garden,'garden',action_)
 for cycle in 16:
  garden=Garden212.tick(garden,1000.,1.);garden=Garden212.action(garden,'harvest');check332(Garden212.clean(round332(garden))==garden,'garden','harvest'+str(cycle));garden=Garden212.action(garden,'plant');garden=Garden212.action(garden,'water')
 results.completed=true
 var f=FileAccess.open('/downloads/audit332-results.json',FileAccess.WRITE);f.store_string(JSON.stringify(results,'  '));f.close()
 print('AUDIT332 DONE ',JSON.stringify(results.counts),' failures ',results.failures.size());get_tree().quit()
func save332(generator:int,seed_:int,flora:Dictionary,towns:Dictionary,policy:Dictionary):
 SaveData.save_path='user://audit332-%s-%s.cfg'%[generator,seed_];SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_generator_version=generator;SaveData.world_seed=seed_;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_flora138=flora.duplicate(true);SaveData.world_cousins140=towns.duplicate(true);SaveData.world_herd_town217=policy.duplicate(true);SaveData.world_pig_captures=[];SaveData.world_goat_captures=[];SaveData.world_tamed=[];SaveData.world_pigs=[];SaveData.world_quests={};SaveData.world_jobs249={};SaveData.world_edits=[];SaveData.country_ledger146=CountryLedger146.fresh(seed_,generator);SaveData.world_missions={};SaveData.repeat_contract165=ProgressionEconomy165.new_contract();SaveData.world_garden212=Garden212.fresh();SaveData.victories240=ModeVictories240.fresh();SaveData.equipment_points=123
 check332(SaveData.save_progress(),'save_write','%s/%s'%[generator,seed_]);var before=FileAccess.get_file_as_bytes(SaveData.save_path)
 SaveData.load_progress();check332(SaveData._load_valid,'save_reload','%s/%s'%[generator,seed_]);check332(before==FileAccess.get_file_as_bytes(SaveData.save_path),'load_readonly','%s/%s'%[generator,seed_]);check332(SaveData.world_herd_town217==policy,'herd_preserved','%s/%s'%[generator,seed_])
 check332(SaveData.record_pig104('audit-pig') and SaveData.record_goat104('audit-goat'),'capture_commit','%s/%s'%[generator,seed_]);SaveData.load_progress();check332(SaveData._load_valid and SaveData.world_pig_captures==['audit-pig'] and SaveData.world_goat_captures==['audit-goat'] and SaveData.equipment_points==203,'capture_reload','%s/%s'%[generator,seed_]);await get_tree().process_frame
