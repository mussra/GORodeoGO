class_name ModeAccess240
extends RefCounted
## Test balance only; all gates share this policy. No currency or waiting.
const RODEO_LEVEL:int=1
const VILLAGES:int=2
const RACE_WINS:int=2
const DUEL_WINS:int=1
const JOUST_WINS:int=1
static func village_count(places:Dictionary)->int:
 var count:int=0
 for id in places.get("visited",{}):
  if id not in ["home","ranch"] and places.visited[id]==true:count+=1
 return count
static func rodeo_offered(quests:Dictionary)->bool:
 return quests.get("farmer_pigs",{}).get("status","")=="done"
static func open(mode:String,highest:int,places:Dictionary,quests:Dictionary,intro:bool,wins:Dictionary,debug:bool=false)->bool:
 if debug:return true
 if mode=="bulls":return intro
 if mode=="race":return open("bulls",highest,places,quests,intro,wins) and highest>=RODEO_LEVEL and village_count(places)>=VILLAGES
 if mode=="duel":return open("race",highest,places,quests,intro,wins) and wins.get("race",0)>=RACE_WINS
 if mode=="joust":return open("duel",highest,places,quests,intro,wins) and wins.get("duel",0)>=DUEL_WINS
 if mode=="memory":return open("joust",highest,places,quests,intro,wins) and wins.get("joust",0)>=JOUST_WINS
 if mode=="cup":return open("duel",highest,places,quests,intro,wins) and wins.get("duel",0)>=DUEL_WINS
 return false
static func requirement(mode:String)->String:
 if mode=="bulls":return "Frontera: ayuda al granjero con los tres cerdos y acepta la misión de Rodeo."
 if mode=="race":return "Supera el nivel %d de Rodeo y visita %d pueblos distintos del rancho."%[RODEO_LEVEL,VILLAGES]
 if mode=="duel":return "Gana %d carreras."%RACE_WINS
 if mode=="joust":return "Gana %d duelo completo (al mejor de tres)."%DUEL_WINS
 if mode=="memory":return "Gana %d justa completa (al mejor de tres)."%JOUST_WINS
 if mode=="cup":return "Gana %d carreras y %d duelo completo."%[RACE_WINS,DUEL_WINS]
 return "Disponible"

static func card_requirement(mode:String)->String:
 if mode=="bulls":return "Pendiente: 3 cerdos y aceptar\nla misión en Frontera."
 if mode=="race":return "Pendiente: gana Rodeo %d\ny visita %d pueblos nuevos."%[RODEO_LEVEL,VILLAGES]
 if mode=="duel":return "Pendiente: gana %d carreras."%RACE_WINS
 if mode=="joust":return "Pendiente: gana %d duelo."%DUEL_WINS
 if mode=="memory":return "Pendiente: gana %d justa."%JOUST_WINS
 return requirement(mode)
