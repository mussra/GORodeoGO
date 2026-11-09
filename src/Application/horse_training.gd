class_name HorseTraining
extends RefCounted
const SKILLS=["jump","dodge"]
const LEARN_TARGET=100.0
const BASE_LEARNING=34.0
const AFFINITY_PER_WIN=10.0
const MAX_RECOVERY_BONUS=.2
static func knows(h:Dictionary,skill:String)->bool:
 if h.is_empty():return false
 return HorseJump.capable(h) if skill=="jump" else bool(h.get("can_dodge",true))
static func mastery(h:Dictionary,skill:String)->float:
 return clampf(float(h.get("mastery",{}).get(skill,0.0)),0,100)
static func progress(h:Dictionary,skill:String)->float:
 return clampf(float(h.get("learning",{}).get(skill,0.0)),0,100)
static func recovery(h:Dictionary,skill:String)->float:
 return 1.0-MAX_RECOVERY_BONUS*mastery(h,skill)/100.0
static func pair_key(a:String,b:String)->String:
 var ids:Array[String]=[a,b];ids.sort();return JSON.stringify(ids)
static func valid(c:HorseCollection,mentor:String,learner:String,skill:String)->bool:
 return skill in SKILLS and mentor!=learner and c.is_adult(mentor) and c.is_adult(learner) and knows(c.find(mentor),skill)
static func configure(c:HorseCollection,mentor:String,learner:String,skill:String)->bool:
 if not valid(c,mentor,learner,skill):return false
 c.training_pair={"mentor":mentor,"learner":learner,"skill":skill};return true
static func session(c:HorseCollection)->Dictionary:
 var p:Dictionary=c.training_pair
 if not valid(c,str(p.get("mentor","")),str(p.get("learner","")),str(p.get("skill",""))):return {}
 if c.selected!=p.learner:return {}
 var snap:Dictionary=p.duplicate(true);snap["mounted_learner"]=c.selected
 return snap
static func complete(c:HorseCollection,pair:Dictionary)->bool:
 if pair.is_empty() or not valid(c,str(pair.get("mentor","")),str(pair.get("learner","")),str(pair.get("skill",""))):return false
 if str(pair.get("mounted_learner",""))!=str(pair.learner):return false
 var learner:Dictionary=c.find(pair.learner);var skill:String=pair.skill
 var key:String=pair_key(pair.mentor,pair.learner);var affinity:float=clampf(float(c.affinities.get(key,0.0)),0,100)
 var boost:float=1.0+affinity/500.0
 if not knows(learner,skill):
  var study:Dictionary=learner.get("learning",{}).duplicate(true);study[skill]=minf(100,progress(learner,skill)+BASE_LEARNING*boost);learner.learning=study
  if study[skill]>=LEARN_TARGET:learner["can_jump" if skill=="jump" else "can_dodge"]=true
 for h in [learner]:
  if not knows(h,skill):continue
  var current:float=mastery(h,skill);var values:Dictionary=h.get("mastery",{}).duplicate(true)
  values[skill]=minf(100,current+(100-current)*.12*boost);h.mastery=values
 c.affinities[key]=minf(100,affinity+AFFINITY_PER_WIN);return true
