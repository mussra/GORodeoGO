class_name GalaxyPure143
extends RefCounted
## Explicit birth proof, never inferred later from editable ancestors or appearance.
const RULE:int=1
const BADGE:String="◆ GALAXY PURO"
static func birth(a:Dictionary,b:Dictionary)->Dictionary:
 if a.is_empty() or b.is_empty() or a.id==b.id:return {}
 for h in [a,b]:
  if h.get("stage","adult")!="adult" or h.get("traits",{}).get("finish","")!="galaxy":return {}
 var snapshot:Array=[]
 for h in [a,b]:snapshot.append({"id":str(h.id),"finish":"galaxy","parents":h.get("parents",[]).duplicate()})
 return {"rule":RULE,"criterion":"two_galaxy_parents","parents":snapshot}
static func valid_record(proof:Variant,parents:Array)->bool:
 if not proof is Dictionary or typeof(proof.get("rule"))!=TYPE_INT or proof.rule!=RULE or proof.get("criterion","")!="two_galaxy_parents":return false
 if not proof.get("parents") is Array or proof.parents.size()!=2 or parents.size()!=2 or parents[0]==parents[1]:return false
 for i in 2:
  var p:Variant=proof.parents[i]
  if not p is Dictionary or p.get("id","")!=parents[i] or p.get("finish","")!="galaxy" or not p.get("parents") is Array or p.parents.size() not in [0,2]:return false
  for id in p.parents:
   if not id is String or id.is_empty():return false
 return true
static func is_pure(h:Dictionary)->bool:
 return h.get("traits",{}).get("finish","")=="galaxy" and valid_record(h.get("galaxy_birth143"),h.get("parents",[]))
