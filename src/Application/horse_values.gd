class_name HorseValues
extends RefCounted
static func visual(t:Dictionary)->Array[String]:
 var spot=HorseCollection.spots_index(t);var legs=HorseCollection.legs_index(t)
 var emblem:String="Ninguno"
 if HorseEmblem.valid(t.get("emblem")):
  var e:Dictionary=t.emblem
  emblem=["Escudo","Círculo","Escudo recto"][e.shape]+(" · "+str(e.get("letters","")) if not str(e.get("letters","")).is_empty() else "")
 return ["Pelaje: "+HorseCollection.COATS[int(t.coat)],"Tipo de manchas: "+HorseCollection.PATTERNS[int(t.pattern)],"Color de manchas: "+(HorseCollection.COATS[spot] if spot>=0 else "Original"),"Crin / cola: "+HorseCollection.MANES[int(t.mane)],"Ojos: "+HorseCollection.EYES[HorseCollection.eye_index(t)],"Patas bajas: "+(HorseCollection.COATS[legs] if legs>=0 else "Original"),"Acabado: "+str(t.get("finish","normal")).capitalize(),"Emblema: "+emblem]
static func performance(h:Dictionary,concrete:bool)->Array[String]:
 if not concrete:return ["Rendimiento y habilidades:", "no definidos hasta conseguirlo."]
 return ["Rendimiento: consulta las barras", "Salto: "+("Disponible" if HorseJump.capable(h) else "Por aprender"),"Esquiva: "+("Disponible" if HorseTraining.knows(h,"dodge") else "Por aprender")]
## Read-only explanation of existing traits, never extra genes or inheritance rules.
static func hidden_genes(t:Dictionary)->Array[String]:
 var lines:Array[String]=[]
 var pattern:int=int(t.get("pattern",0));var spots:int=HorseCollection.spots_index(t)
 var covered:bool=t.get("finish","normal") in ["galaxy","original"]
 var same_color:bool=spots==int(t.get("coat",10))
 # Original giraffe pigment is the same brown as the Castaño coat.
 if spots<0 and ((pattern==10 and int(t.get("coat",10))==10) or (pattern==11 and int(t.get("coat",10))==0)):same_color=true
 if pattern>0 and pattern<HorseCollection.PATTERNS.size() and (covered or (same_color and pattern!=4)):
  lines.append("Lleva gen: "+HorseCollection.PATTERNS[pattern]+" (oculto)")
 if spots>=0 and spots<HorseCollection.COATS.size() and (pattern in [0,4] or covered):
  lines.append("Lleva gen: color de manchas "+HorseCollection.COATS[spots]+" (oculto)")
 return lines
