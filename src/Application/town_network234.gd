class_name TownNetwork234
extends RefCounted
## Seeded cardinal recommendation tree. Explicit three-generation test horizon.
const ROLES:Array[String]=["loco","farmer","florist","saddler"]
const NAMES:Dictionary={"loco":"Loco","farmer":"Granjero","florist":"Florista","saddler":"Guarnicionero"}
const DIRS:Array[Vector2i]=[Vector2i.UP,Vector2i.RIGHT,Vector2i.DOWN,Vector2i.LEFT]
const STEP:float=12288.
static var cache:Dictionary={}
static var focus:Dictionary={}
static var combined:Dictionary={}
static func base_nodes(seed_:int)->Dictionary:
 if cache.has(seed_):return cache[seed_]
 var out:Dictionary={"home":{"id":"home","cell":Vector2i.ZERO,"door":Vector2(1000,358),"parent":"","roles":ROLES.duplicate(),"targets":{},"depth":0}}
 var occupied:Dictionary={Vector2i.ZERO:true};var queue:Array[String]=["home"];var serial:int=0
 while not queue.is_empty():
  var id:String=queue.pop_front();var node:Dictionary=out[id]
  if node.depth>=3:continue
  var rng:=RandomNumberGenerator.new();rng.seed=hash("town-network234-%d-%s"%[seed_,id]);var free:Array[Vector2i]=DIRS.duplicate()
  for i in range(free.size()-1,0,-1):
   var j:=rng.randi_range(0,i);var held:Vector2i=free[i];free[i]=free[j];free[j]=held
  for role in node.roles:
   var chosen:=Vector2i(99,99)
   for direction in free:
    var cell:Vector2i=node.cell+direction
    if occupied.has(cell):continue
    chosen=direction;break
   if chosen==Vector2i(99,99):continue
   free.erase(chosen);serial+=1;var child:String="town%d"%serial
   var cell:Vector2i=node.cell+chosen;occupied[cell]=true
   var roles:Array[String]=[role];var extras:=ROLES.duplicate();extras.erase(role);roles.append(extras[rng.randi_range(0,extras.size()-1)])
   out[child]={"id":child,"cell":cell,"door":position_for(seed_,cell),"parent":id,"roles":roles,"targets":{},"depth":node.depth+1}
   node.targets[role]=child;queue.append(child)
 if cache.size()>20:cache.clear()
 # Some recommendations skip one real, explorable intermediate village.
 for node in out.values():
  node["via"]={}
  for role in node.targets.keys():
   var child:Dictionary=out[node.targets[role]]
   if not child.targets.has(role):continue
   var grand:Dictionary=out[child.targets[role]]
   if grand.cell-child.cell==child.cell-node.cell and posmod(hash("skip234-%d-%s-%s"%[seed_,node.id,role]),2)==0:
    node.via[role]=[child.id];node.targets[role]=grand.id
 cache[seed_]=out;return out
static func doors(seed_:int)->Dictionary:
 var out:Dictionary={}
 for node in nodes(seed_).values():out[node.id]=node.door
 return out
static func direction(from:Vector2,to:Vector2)->String:return VillageCousins140.direction(from,to)
static func point(seed_:int,id:String,role:String)->Vector2:
 var node:Dictionary=nodes(seed_)[id];var index:int=node.roles.find(role)
 if id=="home":
  if role=="farmer":return WorldNominal98.home()+Vector2(90,30)
  if role=="florist":return FloristJourney138.home_door(seed_)+Vector2(110,32)
  return Vector2(900 if role=="loco" else 1500,650)
 return node.door+Vector2(-220+index*440,30)
static func role_text(seed_:int,id:String)->String:
 var parts:PackedStringArray=[]
 for role in nodes(seed_)[id].roles:parts.append(npc_name(id,role))
 return " · ".join(parts)
static func roads(seed_:int,plans:Dictionary)->Array:
 var out:Array=[];var links:Dictionary={};var all:=nodes(seed_)
 for node in all.values():
  if not node.parent.is_empty():links[node.parent+"|"+node.id]=[node.parent,node.id]
  if node.id.begins_with("extra:"):
   var parent:=cell_node(seed_,territory_parent(seed_,node.cell))
   if all.has(parent.id):links[parent.id+"|"+node.id]=[parent.id,node.id]
 for pair in links.values():out.append(link_path(seed_,pair[0],pair[1],plans))
 return out
static func link_path(seed_:int,from:String,to:String,plans:Dictionary)->PackedVector2Array:
 var a:Vector2=plans[from].gate+Vector2(0,400);var b:Vector2=plans[to].gate+Vector2(0,400)
 var path:=PackedVector2Array([plans[from].gate,a])
 if absf(node_for(seed_,from).door.y-node_for(seed_,to).door.y)>1.:
  var x:float=node_for(seed_,from).door.x+3000.;path.append(Vector2(x,a.y));path.append(Vector2(x,b.y))
 path.append(b);path.append(plans[to].gate);return path

static func position_for(seed_:int,cell:Vector2i)->Vector2:
 var jitter:=Vector2.ZERO
 if cell.x!=0:jitter.x=float(posmod(hash("town-x236-%d-%d"%[seed_,cell.x]),5001)-2500)
 if cell.y!=0:jitter.y=float(posmod(hash("town-y236-%d-%d"%[seed_,cell.y]),5001)-2500)
 return Vector2(1000,358)+Vector2(cell)*STEP+jitter
static func cell_at(seed_:int,p:Vector2)->Vector2i:
 var guess:=Vector2i(((p-Vector2(1000,358))/STEP).round());var best:=guess;var distance:float=INF
 for x in range(guess.x-1,guess.x+2):
  for y in range(guess.y-1,guess.y+2):
   var cell:=Vector2i(x,y);var d:=position_for(seed_,cell).distance_squared_to(p)
   if d<distance:distance=d;best=cell
 return best
static func ensure_near(seed_:int,p:Vector2):
 var c:=cell_at(seed_,p)
 if focus.get(seed_,Vector2i(999999,999999))==c:return
 focus[seed_]=c;combined.erase(seed_);TownEnclosures227.cache.clear();RoadNetwork230.cache.clear()
 if not SaveData.world_herd_town217.is_empty():
  var towns:Dictionary=SaveData.world_herd_town217.towns.duplicate(true)
  towns.doors=doors(seed_);towns.towns215=TownIdentity215.fresh(seed_);SaveData.world_herd_town217.towns=towns
static func cell_node(seed_:int,cell:Vector2i)->Dictionary:
 for item in base_nodes(seed_).values():
  if item.cell==cell:return item
 var id:String="extra:%d:%d"%[cell.x,cell.y];var rng:=RandomNumberGenerator.new();rng.seed=hash("territory236-%d-%s"%[seed_,id]);var first:int=rng.randi_range(0,3);var second:int=posmod(first+rng.randi_range(1,3),4)
 return {"id":id,"cell":cell,"door":position_for(seed_,cell),"parent":"","roles":[ROLES[first],ROLES[second]],"targets":{},"via":{},"depth":4}
static func nodes(seed_:int)->Dictionary:
 if combined.has(seed_):return combined[seed_]
 var result:=base_nodes(seed_).duplicate(true);var center:Vector2i=focus.get(seed_,Vector2i.ZERO)
 for x in range(center.x-2,center.x+3):
  for y in range(center.y-2,center.y+3):
   var item:=cell_node(seed_,Vector2i(x,y));result[item.id]=item
 combined[seed_]=result;return result
static func node_for(seed_:int,id:String)->Dictionary:
 if base_nodes(seed_).has(id):return base_nodes(seed_)[id]
 var parts:=id.split(":")
 if parts.size()==3 and parts[0]=="extra" and parts[1].is_valid_int() and parts[2].is_valid_int():return cell_node(seed_,Vector2i(int(parts[1]),int(parts[2])))
 return {}
static func recommendation_path(seed_:int,town:String,role:String)->Array:
 var node:=node_for(seed_,town);var result:Array=[town]
 result.append_array(node.get("via",{}).get(role,[]))
 if node.targets.has(role):result.append(node.targets[role])
 return result

static func territory_parent(seed_:int,cell:Vector2i)->Vector2i:
 var nearest:=Vector2i.ZERO;var best:int=2147483647
 for core in base_nodes(seed_).values():
  var d:int=absi(cell.x-core.cell.x)+absi(cell.y-core.cell.y)
  if d<best:best=d;nearest=core.cell
 var options:Array[Vector2i]=[]
 if cell.x!=nearest.x:options.append(cell+Vector2i(signi(nearest.x-cell.x),0))
 if cell.y!=nearest.y:options.append(cell+Vector2i(0,signi(nearest.y-cell.y)))
 return options[posmod(hash("territory-parent236-%d-%d-%d"%[seed_,cell.x,cell.y]),options.size())] if not options.is_empty() else cell

static func npc_name(town:String,role:String)->String:
 return "Juanito · guarnicionero" if town=="home" and role=="saddler" else NAMES[role]
