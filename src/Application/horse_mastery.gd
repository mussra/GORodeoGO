class_name HorseMastery
extends RefCounted
## Overall mission mastery is distinct level coverage, not skill mastery or calm.
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
static func percent(h:Dictionary)->float:return maxf(campaign_percent173(h,1),campaign_percent173(h,2))
static func galaxy_master(h:Dictionary,threshold:float=GALAXY_MASTER_THRESHOLD)->bool:
 return h.get("stage","adult")=="adult" and h.get("traits",{}).get("finish","")=="galaxy" and percent(h)>=clampf(threshold,0,100)
static func record(c:HorseCollection,id:String,level:int)->bool:
 var horse=c.find(id)
 if horse.is_empty() or horse.get("stage","adult")!="adult" or level<1 or level>LevelCatalog.MAX_LEVEL:return false
 var done=levels(horse)
 if done.has(level):return false
 done.append(level);done.sort();horse["completed_levels"]=done;return true
static func level_text(h:Dictionary)->String:
 var done=levels(h);var parts:PackedStringArray=[]
 for n in done:parts.append(str(n))
 return "Campaña I: %d%% · Campaña II: %d%%\nNiveles superados: "%[roundi(campaign_percent173(h,1)),roundi(campaign_percent173(h,2))]+(", ".join(parts) if not done.is_empty() else "Sin registro por caballo")
