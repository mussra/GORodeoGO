class_name TownMessages247
extends RefCounted
## A discovered village is not a heard message. Keep each office independent.
const PLURALS:Dictionary={'loco':'tus primos','farmer':'los granjeros','florist':'las floristas','saddler':'los guarnicioneros'}
static func key(town:String,role:String)->String:return town+'|'+role
static func pending(seed_:int,state:Dictionary,role:String)->Array[String]:
 var nodes:Array=TownNetwork234.base_nodes(seed_).values()
 nodes.sort_custom(func(a,b):return a.depth<b.depth if a.depth!=b.depth else str(a.id).naturalnocasecmp_to(str(b.id))<0)
 var out:Array[String]=[]
 for node in nodes:
  if role in node.roles and not state.get('heard247',{}).has(key(node.id,role)):out.append(node.id)
 return out
static func message(seed_:int,town:String,role:String)->String:
 var node:Dictionary=TownNetwork234.node_for(seed_,town)
 var target:String=node.get('targets',{}).get(role,'')
 if target.is_empty():return 'En %s puedes hablar con %s.'%[TownIdentity215.title(SaveData.world_cousins140,town),TownNetwork234.role_text(seed_,town)]
 return 'En %s te recomiendan visitar %s, hacia el %s.'%[TownIdentity215.title(SaveData.world_cousins140,town),TownIdentity215.title(SaveData.world_cousins140,target),TownNetwork234.direction(node.door,TownNetwork234.node_for(seed_,target).door)]
static func open(seed_:int,state:Dictionary,town:String,role:String)->Dictionary:
 var next:Dictionary=state.duplicate(true)
 if not next.get('heard247') is Dictionary:next['heard247']={}
 next.heard247[key(town,role)]='direct'
 var node:Dictionary=TownNetwork234.node_for(seed_,town)
 var target:String=node.get('targets',{}).get(role,'')
 # Preserve a real forward recommendation. Only replace a false terminal.
 if not target.is_empty():return {'state':next,'target':target,'relayed':'','complete':false}
 var missing:Array[String]=pending(seed_,next,role)
 var relay:String=''
 if not missing.is_empty():
  relay=missing.pop_front();next.heard247[key(relay,role)]='relayed'
 return {'state':next,'target':missing[0] if not missing.is_empty() else '', 'relayed':relay,'complete':missing.is_empty()}
static func clean(raw:Variant,seed_:int)->Dictionary:
 var out:Dictionary={}
 if not raw is Dictionary:return out
 for id in raw:
  if not id is String:continue
  var parts:PackedStringArray=id.split('|')
  if parts.size()!=2 or parts[1] not in TownNetwork234.ROLES or raw[id] not in ['direct','relayed']:continue
  var node:Dictionary=TownNetwork234.node_for(seed_,parts[0])
  if not node.is_empty() and parts[1] in node.roles:out[id]=raw[id]
 return out
