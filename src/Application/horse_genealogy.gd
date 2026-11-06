class_name HorseGenealogy
extends RefCounted
## Read-only graph over known records. No inferred identities, roots or race.
static func records(collection:HorseCollection)->Array[Dictionary]:
 var all:Array[Dictionary]=collection.ancestors.duplicate(true);all.append_array(collection.horses);return all
static func generation(id:String,by_id:Dictionary,memo:Dictionary,visiting:Dictionary)->int:
 if memo.has(id):return memo[id]
 if visiting.has(id) or not by_id.has(id):return 0
 visiting[id]=true;var depth:int=0
 for p in by_id[id].get("parents",[]):depth=maxi(depth,1+generation(p,by_id,memo,visiting))
 visiting.erase(id);memo[id]=depth;return depth
static func layout(collection:HorseCollection)->Dictionary:
 var by_id:Dictionary={};var memo:Dictionary={};var columns:Dictionary={};var positions:Dictionary={}
 for h in records(collection):by_id[h.id]=h
 for h in records(collection):
  var g:int=generation(h.id,by_id,memo,{})
  if not columns.has(g):columns[g]=0
  positions[h.id]=Vector2(40+columns[g]*260,40+g*215);columns[g]+=1
 return positions
static func matches(h:Dictionary,text:String,filters:Dictionary)->bool:
 var q:String=text.strip_edges().to_lower()
 if not q.is_empty() and not (str(h.name)+" "+str(h.id)).to_lower().contains(q):return false
 for key in filters:
  var value:int=int(filters[key])
  if value<0:continue
  if int(h.traits.get(key,10 if key=="eyes" else -1))!=value:return false
 return true
static func lineage(h:Dictionary)->String:
 var label:String=str(h.get("lineage_label",h.get("breed_label","")))
 return label if not label.is_empty() else TranslationServer.translate("GEN_UNKNOWN")
static func origin(h:Dictionary)->String:
 var value:String=str(h.get("origin",""))
 if value=="purchased":return TranslationServer.translate("GEN_PURCHASED")
 if not h.get("parents",[]).is_empty():return TranslationServer.translate("GEN_BRED")
 return TranslationServer.translate("GEN_UNRECORDED")

## Independent walks: a descendant's other parent is not the selected horse's ancestor.
## Sets prevent shared-ancestor duplicates and terminate even on malformed cyclic input.
static func related_paths(collection:HorseCollection,id:String)->Dictionary:
 var by_id:Dictionary={};var children:Dictionary={};var nodes:Dictionary={};var edges:Dictionary={}
 for h in records(collection):
  by_id[h.id]=h
  for parent in h.get("parents",[]):
   if not children.has(parent):children[parent]=[]
   children[parent].append(h.id)
 if not by_id.has(id):return {"nodes":nodes,"edges":edges}
 nodes[id]=true
 for ascending in [true,false]:
  var pending:Array=[id];var seen:Dictionary={}
  while not pending.is_empty():
   var current:String=pending.pop_back()
   if seen.has(current):continue
   seen[current]=true
   var next:Array=by_id[current].get("parents",[]) if ascending else children.get(current,[])
   for other in next:
    if not by_id.has(other):continue
    nodes[other]=true
    var parent:String=other if ascending else current
    var child:String=current if ascending else other
    edges[[parent,child]]=true
    if not seen.has(other):pending.append(other)
 return {"nodes":nodes,"edges":edges}
