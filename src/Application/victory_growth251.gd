class_name VictoryGrowth251
extends RefCounted
const PRIMARY={"bulls":"power","race":"speed","duel":"handling","joust":"dodge","memory":"calm","cup":"speed"}
static func apply(collection:HorseCollection,id:String,mode:String)->Dictionary:
 var horse:=collection.find(id)
 if horse.is_empty() or horse.get("stage","adult")!="adult" or not PRIMARY.has(mode):return {}
 var key:String=PRIMARY[mode];var before:float=HorseStats.read(horse)[key]
 var counts:Dictionary=horse.get("growth251",{}).duplicate(true);counts[key]=int(counts.get(key,0))+1;horse.growth251=counts
 var wins:Dictionary=horse.get("mode_wins251",{}).duplicate(true);wins[mode]=int(wins.get(mode,0))+1;horse.mode_wins251=wins
 var after:float=HorseStats.read(horse)[key]
 for spec in HorseSummary185.STATS:
  if spec[1]==key:return {"horse":horse.duplicate(true),"id":id,"mode":mode,"key":key,"title":spec[0],"before":before,"after":after,"low":spec[2],"high":maxf(spec[3],after+(spec[3]-spec[2])*.1)}
 return {}
static func bonus(key:String,count:int)->float:
 for spec in HorseSummary185.STATS:
  if spec[1]==key:return (spec[3]-spec[2])*.02*sqrt(float(maxi(count,0)))
 return 0.
static func visual(spec:Array,value:float)->float:
 var x:float=maxf(0.,(value-float(spec[2]))/(float(spec[3])-float(spec[2])))
 return x if x<=.5 else .5+.5*(1.-exp(-(x-.5)*2.))
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
    var counts:Dictionary=existing.get("growth251",{}).duplicate();counts[spec[1]]=int(counts.get(spec[1],0))+25;existing.growth251=counts
   return existing
  return {}
 var h:Dictionary={"id":prize_id,"name":HorseCollection.PATTERNS[int(horse.traits.pattern)]+" · Linaje maestro","parents":[],"origin":"mastery251","mastered_from251":id,"lineage_label":HorseCollection.PATTERNS[int(horse.traits.pattern)],"traits":horse.traits.duplicate(true),"species":horse.get("species","horse"),"can_jump":true,"can_dodge":true,"stats":HorseStats.read(horse),"growth251":{},"master251":true,"supreme251":full_master(horse)}
 # Match the best effective property in this family, then add one extra growth step.
 for spec in HorseSummary185.STATS:
  var best:float=h.stats[spec[1]]
  for candidate in collection.horses:
   if family(candidate)==key:best=maxf(best,HorseStats.read(candidate)[spec[1]])
  h.stats[spec[1]]=minf(best,spec[3]);var n:int=maxi(1,int(pow(maxf(0.,best-h.stats[spec[1]])/((spec[3]-spec[2])*.02),2.))+1)
  h.growth251[spec[1]]=n+(25 if full_master(horse) else 0)
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
