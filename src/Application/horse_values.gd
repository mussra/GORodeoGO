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
