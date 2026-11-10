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
 var s=HorseStats.read(h)
 return ["Velocidad: %.0f · Manejo: %.0f"%[s.speed,s.handling],"Fuerza: %.0f%% · Esquiva: %.0f%%"%[s.power*100,s.dodge*100],"Serenidad: %.2f"%s.calm,"Salto: "+("Sí" if HorseJump.capable(h) else "No")+" · dominio %.0f%% · aprendizaje %.0f%%"%[HorseTraining.mastery(h,"jump"),HorseTraining.progress(h,"jump")],"Esquiva: "+("Sí" if HorseTraining.knows(h,"dodge") else "No")+" · dominio %.0f%% · aprendizaje %.0f%%"%[HorseTraining.mastery(h,"dodge"),HorseTraining.progress(h,"dodge")]]
