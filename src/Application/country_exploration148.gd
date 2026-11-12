class_name CountryExploration148
extends RefCounted
const CELL:float=512.
const NAMES:Dictionary={"entry":"Entrada del país","tree":"Raíces del árbol","source":"Nacimiento del río"}
static func reveal(cells:Dictionary,position_:Vector2)->void:
 # Only the current camera's immediate area, never an automatic route reveal.
 for x in range(-1,2):
  for y in range(-1,2):
   var cell:=Vector2i(floori(position_.x/CELL)+x,floori(position_.y/CELL)+y)
   if CountryRoute146.BOUNDS.intersects(Rect2(Vector2(cell)*CELL,Vector2.ONE*CELL)):cells[cell]=true
static func available(ledger:Dictionary,data:Dictionary)->Array[Dictionary]:
 var result:Array[Dictionary]=[]
 var visited:Dictionary=ledger.get("maps",{}).get(CountryRoute146.ID,{}).get("visited",{})
 for id in ["entry","tree","source"]:
  if visited.get(id,false):result.append({"id":id,"name":NAMES[id],"pos":data.sites[id]})
 return result
static func destination(ledger:Dictionary,data:Dictionary,id:String)->Dictionary:
 for site in available(ledger,data):
  if site.id==id:return site
 return {}
