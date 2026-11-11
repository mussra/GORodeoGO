class_name UnicornAtlas
extends RefCounted
## Separate identity, never inferred from the existing cosmetic finish=galaxy.
const VARIANTS:Dictionary={"blue":"Galaxy azul","pink":"Galaxy rosa","green":"Galaxy verde","red":"Galaxy rojo","black":"Galaxy negro"}
static func entries(horses:Array)->Array[Dictionary]:
 var out:Array[Dictionary]=[]
 for key in VARIANTS:
  var owned:Dictionary={}
  for h in horses:
   if h.get("species","")=="unicorn" and h.get("unicorn_variant","")==key:owned=h;break
  out.append({"variant":key,"name":VARIANTS[key],"owned":not owned.is_empty(),"horse":owned,"silhouette":owned.is_empty()})
 return out
