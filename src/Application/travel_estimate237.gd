class_name TravelEstimate237
extends RefCounted
## Route-following model, not a guarantee. Uses the exact mounted stamina rules.
static func seconds(distance:float,horse:Dictionary,energy:Dictionary={},nutrition:float=1.)->float:
 var stats:=HorseStats.read(horse);var state:Dictionary=energy.duplicate(true) if not energy.is_empty() else WorldStamina.new_state(stats.power)
 var remaining:float=maxf(0.,distance);var elapsed:float=0.;var dt:float=.25
 while remaining>0. and elapsed<86400.:
  var gait:int=WorldStamina.cap_gait(state,WorldGait.GALOPE);var speed:float=WorldGait.speed_for(gait,stats.speed)
  var step:float=minf(dt,remaining/maxf(1.,speed));remaining-=speed*step;elapsed+=step;state=WorldStamina.tick(state,gait,true,step,true,nutrition)
 return elapsed
static func route(seed_:int,town:String,role:String)->Dictionary:
 var ids:=TownNetwork234.recommendation_path(seed_,town,role);var plans:=TownEnclosures227.plans(seed_);var distance:float=0.;var paths:Array=[]
 for i in range(ids.size()-1):
  var path:=TownNetwork234.link_path(seed_,ids[i],ids[i+1],plans)
  for j in path.size()-1:distance+=path[j].distance_to(path[j+1])
  paths.append(path)
 if not ids.is_empty():
  distance+=TownNetwork234.point(seed_,town,role).distance_to(plans[town].gate)
  var last:String=ids[-1];distance+=TownNetwork234.point(seed_,last,role).distance_to(plans[last].gate)
 return {"distance":distance,"hops":ids.size()-1,"ids":ids,"paths":paths}
static func text(seconds_:float)->String:
 var low:int=int(floor(seconds_*.8/10.))*10;var high:int=int(ceil(seconds_*1.2/10.))*10
 return clock(low)+" - "+clock(high)
static func clock(seconds_:int)->String:return "%d min %02d s"%[seconds_/60,seconds_%60]
