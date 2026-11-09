class_name TrainingReport
extends RefCounted
static func snapshot(c:HorseCollection,pair:Dictionary)->Dictionary:
 if pair.is_empty():return {}
 var h:Dictionary=c.find(str(pair.get("learner","")))
 if h.is_empty():return {}
 var skill:String=str(pair.get("skill","jump"))
 return {"learning":HorseTraining.progress(h,skill),"mastery":HorseTraining.mastery(h,skill),"affinity":float(c.affinities.get(HorseTraining.pair_key(str(pair.mentor),str(pair.learner)),0.0)),"name":str(h.name),"skill":skill}
static func gain(before:Dictionary,after:Dictionary,key:String)->float:
 return maxf(0.0,float(after.get(key,0.0))-float(before.get(key,0.0)))
