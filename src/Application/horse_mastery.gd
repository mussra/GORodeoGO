class_name HorseMastery
extends RefCounted
## New mastery requires distinct wins in 36-40 with this horse. Old earned mastery is retained.
const GALAXY_MASTER_THRESHOLD:float=100.0
static func levels(h:Dictionary)->Array[int]:
 var result:Array[int]=[]
 for n in h.get("completed_levels",[]):
  if n is int and n>=1 and n<=LevelCatalog.MAX_LEVEL and not result.has(n):result.append(n)
 result.sort();return result
static func campaign_percent173(h:Dictionary,campaign:int)->float:
 var count:int=0
 for level in levels(h):
  if level>(campaign-1)*20 and level<=campaign*20:count+=1
 return float(count)*5.
static func legacy_master179(h:Dictionary)->bool:
 return h.get("mastery_legacy179",false) or (not h.has("mastery_rule179") and (campaign_percent173(h,1)>=100. or campaign_percent173(h,2)>=100.))
static func migrate179(h:Dictionary)->void:
 if h.has("mastery_rule179"):return
 if legacy_master179(h):h["mastery_legacy179"]=true
 h["mastery_rule179"]=1
static func final_count179(h:Dictionary)->int:
 var count:int=0
 for n in levels(h):
  if n>=36 and n<=40:count+=1
 return count
static func percent(h:Dictionary)->float:
 return 100. if legacy_master179(h) else float(final_count179(h))*20.
static func galaxy_master(h:Dictionary,threshold:float=GALAXY_MASTER_THRESHOLD)->bool:
 return h.get("stage","adult")=="adult" and h.get("traits",{}).get("finish","")=="galaxy" and percent(h)>=clampf(threshold,0,100)
static func record(c:HorseCollection,id:String,level:int)->bool:
 var horse=c.find(id)
 if horse.is_empty() or horse.get("stage","adult")!="adult" or level<1 or level>LevelCatalog.MAX_LEVEL:return false
 migrate179(horse)
 var done=levels(horse)
 if done.has(level):return false
 done.append(level);done.sort();horse["completed_levels"]=done;return true
static func level_text(h:Dictionary)->String:
 var done=levels(h);var parts:PackedStringArray=[]
 for n in done:parts.append(str(n))
 return ("Maestría anterior conservada" if legacy_master179(h) else "Maestría: niveles 36-40 · %d/5"%final_count179(h))+"\nNiveles superados: "+(", ".join(parts) if not done.is_empty() else "Sin registro por caballo")
