class_name VictoryGrowth251
extends RefCounted
const PRIMARY={"bulls":"power","race":"speed","duel":"handling","joust":"dodge","memory":"calm","cup":"speed"}
static func apply(collection:HorseCollection,id:String,mode:String)->Dictionary:
 var horse:=collection.find(id)
 if horse.is_empty() or horse.get("stage","adult")!="adult" or not PRIMARY.has(mode):return {}
 var keys:Array=["handling","calm"] if mode=="duel" else ["dodge","handling","calm"] if mode=="joust" else [PRIMARY[mode]]
 var before_stats:=HorseStats.read(horse)
 for key in keys:HorseStats.grow255(horse,key)
 var wins:Dictionary=horse.get("mode_wins251",{}).duplicate(true);wins[mode]=int(wins.get(mode,0))+1;horse.mode_wins251=wins
 var after_stats:=HorseStats.read(horse);var changes:Array=[]
 # Primary first preserves the existing reward envelope and single-row callers.
 keys.erase(PRIMARY[mode]);keys.push_front(PRIMARY[mode])
 for key in keys:
  for spec in HorseSummary185.STATS:
   if spec[1]!=key:continue
   changes.append({"key":key,"title":spec[0],"before":before_stats[key],"after":after_stats[key],"low":spec[2],"high":spec[3],"points":(after_stats[key]-before_stats[key])/(spec[3]-spec[2])*100.})
 var result:Dictionary=changes[0].duplicate(true);result.merge({"horse":horse.duplicate(true),"id":id,"mode":mode,"changes254":changes})
 return result
static func delta_text254(change:Dictionary)->String:
 var points:float=change.get("points",(change.after-change.before)/(change.high-change.low)*100.)
 var text_:String=String.num(points,2 if points>=.1 else 4)
 if text_.contains("."):text_=text_.rstrip("0").rstrip(".")
 return "+"+text_.replace(".",",")+" pts"
static func bonus(key:String,count:int)->float:
 for spec in HorseSummary185.STATS:
  if spec[1]==key:return (spec[3]-spec[2])*.02*sqrt(float(maxi(count,0)))
 return 0.
static func visual(spec:Array,value:float)->float:
 return clampf((value-float(spec[2]))/(float(spec[3])-float(spec[2])),0.,1.)
static func race_horse(collection:HorseCollection,sequence:int)->Dictionary:
 var id:String="race_prize251_"+str(sequence)
 if not collection.known_record(id).is_empty():return {}
 var h:Dictionary={"id":id,"name":"","parents":[],"origin":"race_prize251","traits":{"coat":posmod(sequence*7,HorseCollection.COATS.size()),"pattern":posmod(sequence*5,HorseCollection.PATTERNS.size()),"mane":posmod(sequence,6),"eyes":posmod(sequence*3,20),"finish":"normal"},"can_jump":true}
 h.name=collection.suggest_name(h.traits)+" · Carrera "+str(sequence);collection.horses.append(h);return h
static func family(h:Dictionary)->String:return str(h.get("species","horse"))+":"+str(h.traits.pattern)
static func champion(collection:HorseCollection,id:String)->Dictionary:
 var horse:=collection.find(id)
 if horse.is_empty() or not family_ready(collection,horse):return {}
 var key:String=family(horse);var prize_id:String="lineage251_"+key.replace(":","_")
 if full_master(horse):horse["supreme251"]=true
 horse["master251"]=true
 for member in collection.horses:
  if family(member)==key:member["master251"]=true
 var existing:=collection.known_record(prize_id)
 if not existing.is_empty():
  if full_master(horse) and not existing.get("supreme251",false):
   existing["supreme251"]=true;existing["master251"]=true
   for spec in HorseSummary185.STATS:
    HorseStats.grow255(existing,spec[1],25)
   return existing
  return {}
 var h:Dictionary={"id":prize_id,"name":HorseCollection.PATTERNS[int(horse.traits.pattern)]+" · Linaje maestro","parents":[],"origin":"mastery251","mastered_from251":id,"lineage_label":HorseCollection.PATTERNS[int(horse.traits.pattern)],"traits":horse.traits.duplicate(true),"species":horse.get("species","horse"),"can_jump":true,"can_dodge":true,"stats":HorseStats.read(horse),"growth251":{},"growth_capped255":true,"master251":true,"supreme251":full_master(horse)}
 # Match the best effective property in this family, then add one extra growth step.
 for spec in HorseSummary185.STATS:
  var best:float=h.stats[spec[1]]
  for candidate in collection.horses:
   if family(candidate)==key:best=maxf(best,HorseStats.read(candidate)[spec[1]])
  h.stats[spec[1]]=minf(best,spec[3]);HorseStats.grow255(h,spec[1],26 if full_master(horse) else 1)
 if horse.has("unicorn_variant"):h.unicorn_variant=horse.unicorn_variant
 collection.horses.append(h);return h
static func full_master(h:Dictionary)->bool:
 var wins:Dictionary=h.get("mode_wins251",{})
 return HorseMastery.levels(h).size()>=40 and h.get("race_courses251",[]).size()>=4 and ["duel","joust","memory"].all(func(mode):return int(wins.get(mode,0))>0)
static func family_progress(collection:HorseCollection,h:Dictionary)->Dictionary:
 var levels:Array=[];var courses:Array=[];var modes:Dictionary={}
 for candidate in collection.horses+collection.ancestors:
  if family(candidate)!=family(h):continue
  for level in HorseMastery.levels(candidate):
   if level not in levels:levels.append(level)
  for course in candidate.get("race_courses251",[]):
   if course not in courses:courses.append(course)
  for mode in ["duel","joust","memory"]:
   if int(candidate.get("mode_wins251",{}).get(mode,0))>0:modes[mode]=true
 return {"levels":levels.size(),"courses":courses.size(),"modes":modes}
static func family_ready(collection:HorseCollection,h:Dictionary)->bool:
 var p:=family_progress(collection,h)
 return p.levels>=6 and p.courses>=2 and p.modes.size()>=3
static func family_text(collection:HorseCollection,h:Dictionary)->String:
 var key:String=family(h);var best:Dictionary=h;var score:float=-1.
 for candidate in collection.horses:
  if family(candidate)!=key:continue
  var value:float=0.
  for spec in HorseSummary185.STATS:value+=(HorseStats.read(candidate)[spec[1]]-spec[2])/(spec[3]-spec[2])
  if value>score:score=value;best=candidate
 var text_:String="Familia: "+HorseCollection.PATTERNS[int(h.traits.pattern)]+" · Mejor de tu cuadra: "+str(best.name)
 var progress:=family_progress(collection,h)
 text_+="\nLinaje compartido: %d/6 toros distintos · %d/2 circuitos · %d/3 otros juegos"%[mini(progress.levels,6),mini(progress.courses,2),progress.modes.size()]
 text_+="\nDuelo: "+("hecho" if progress.modes.has("duel") else "pendiente")+" · Justa: "+("hecho" if progress.modes.has("joust") else "pendiente")+" · Hípica: "+("hecho" if progress.modes.has("memory") else "pendiente")
 if h.has("mastered_from251"):text_+="\nExclusivo de maestría · conseguido con "+str(collection.known_record(h.mastered_from251).get("name",h.mastered_from251))
 elif not collection.known_record("lineage251_"+key.replace(":","_")).is_empty():text_+="\nLinaje exclusivo desbloqueado. No necesitas repetirlo con cada caballo."
 else:text_+="\nProgreso compartido por familia. Completa los cinco juegos para su caballo exclusivo."
 return text_
