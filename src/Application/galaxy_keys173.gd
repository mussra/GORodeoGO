class_name GalaxyKeys173
extends RefCounted
const MILESTONES:Array[int]=[20,40]
static func claimed(c:HorseCollection,highest:int)->Array[int]:
 var result:Array[int]=[]
 for value in c.galaxy_keys173:
  if value in MILESTONES and not result.has(value):result.append(value)
 if c.galaxy_rule173==0:
  var legacy:int=0
  for h in c.horses+c.ancestors:
   if h.get("traits",{}).get("finish","")=="galaxy" and h.get("parents",[]).is_empty():legacy+=1
  for milestone in MILESTONES:
   if milestone<=highest and legacy>0 and not result.has(milestone):result.append(milestone);legacy-=1
 return result
static func available(c:HorseCollection,highest:int)->Array[int]:
 var used:=claimed(c,highest);var out:Array[int]=[]
 for milestone in MILESTONES:
  if milestone<=highest and not used.has(milestone):out.append(milestone)
 return out
static func migrate(c:HorseCollection,highest:int)->void:
 if c.galaxy_rule173>0:return
 c.galaxy_keys173=claimed(c,highest);c.galaxy_rule173=1
static func consume(c:HorseCollection,highest:int,milestone:int=0)->bool:
 migrate(c,highest);var keys:=available(c,highest)
 if keys.is_empty():return false
 var selected:int=keys[0] if milestone==0 else milestone
 if not keys.has(selected):return false
 c.galaxy_keys173.append(selected);return true
