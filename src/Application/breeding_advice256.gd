class_name BreedingAdvice256
extends RefCounted
const IDS=["breeding","mean","caps","mastery","breeds","lineage"]
const TITLES=["Criar con calma","La media de sus padres","Mejorar sin sobrepasar","Camino a la maestría","Razas y apariencias","Tu linaje, tu marca"]
const TIPS=[
 ["Pablo, elige dos adultos distintos de tu cuadra.","Cuida al potro con 10 victorias o encargos repetibles cobrados.","Salto y Esquiva se aprenden: no vienen regalados por cruzar."],
 ["Cada propiedad de la cría es la media de ambos padres.","Las mejoras ganadas por los padres también cuentan.","Ejemplo: Velocidad 260 + 280 da una cría con 270."],
 ["Cada barra tiene un máximo: nunca se sobrepasa.","Toros: Fuerza. Carrera: Velocidad y un caballo.","Duelo: Manejo y Serenidad. Justa añade Agilidad."],
 ["Una familia comparte su avance: especie y patrón.","Completa 6 toros distintos, 2 circuitos, Duelo, Justa e Hípica.","Brillo y un exclusivo por familia. Los hijos de su patrón conservan la maestría."],
 ["Pelaje y patrón describen el aspecto, no una raza real.","Galaxy es un acabado. Dos padres Galaxy dan cría Galaxy.","Los unicornios son otra especie. El Atlas muestra los descubiertos."],
 ["El árbol genealógico guarda padres y descendientes.","El escudo identifica a tu caballo: no mejora propiedades.","La marca no sustituye las pruebas ni regala otro exclusivo."]]
static func state()->Dictionary:
 var cfg:=ConfigFile.new()
 if cfg.load(path())==OK:
  var result:Variant=cfg.get_value("advice","read",{})
  if result is Dictionary:return result
 return {}
static func path()->String:return "user://breeding_advice256_"+SaveData.save_path.get_file()+".cfg"
static func mark(id:String)->bool:
 if id not in IDS:return false
 var data:=state();data[id]=true
 var cfg:=ConfigFile.new();cfg.set_value("advice","read",data)
 return cfg.save(path())==OK
static func inherit_mastery(collection:HorseCollection,child:Dictionary,a:Dictionary,b:Dictionary)->void:
 # A mastered parent passes the family's earned badge, not content completion
 # or the identity/stat bonus of the one exclusive family reward.
 for parent in [a,b]:
  if parent.get("master251",false) and VictoryGrowth251.family(parent)==VictoryGrowth251.family(child):
   child.master251=true;child.master_inherited256=true
   return
static func mentor_position()->Vector2:
 return (WorldNominal98.home() if WorldNominal98.enabled() else Vector2(640,360))+Vector2(160,100)
static func mentor()->Dictionary:return {"id":"mentor256","name":"Alma · Crianza","position":mentor_position(),"quests":[]}
