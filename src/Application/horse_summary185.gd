class_name HorseSummary185
extends RefCounted
# These are the same bounds used by the detailed property bars.
const STATS=[["Velocidad","speed",240.,300.],["Manejo","handling",600.,1500.],["Fuerza","power",.5,.9],["Agilidad","dodge",.75,1.],["Serenidad","calm",.5,2.]]
static func values(h:Dictionary)->Array[float]:
 var result:Array[float]=[];var stats:Dictionary=HorseStats.read(h)
 for spec in STATS:result.append(clampf(inverse_lerp(spec[2],spec[3],stats[spec[1]]),0.,1.)*100.)
 for skill in HorseTraining.SKILLS:result.append(100. if HorseTraining.knows(h,skill) else HorseTraining.progress(h,skill))
 result.append(HorseMastery.percent(h));return result
static func average(h:Dictionary)->float:
 var items:=values(h);var total:float=0.
 for value in items:total+=value
 return total/items.size()
const HELP="Promedio con igual peso de 8 propiedades: Velocidad, Manejo, Fuerza, Agilidad, Serenidad, aprendizaje de Salto, aprendizaje de Esquiva y Maestría. Cada una usa la escala de 0 a 100 de la ficha. Una habilidad aprendida aporta 100; si no, su progreso de aprendizaje. No incluye pelaje, rareza, genes ni equipo."
