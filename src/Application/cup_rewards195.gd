class_name CupRewards195
extends RefCounted
## One transaction: horse and elemental receipt live in the same collection snapshot.
const RECEIPT="rancho_cup195"
const HORSE="cup195_brisa_alba"
const TEMPER="crossing_calm"
static func horse()->Dictionary:
 return {"id":HORSE,"name":"Brisa del Alba","parents":[],"stage":"adult","can_jump":true,"cup_temper195":TEMPER,"traits":{"coat":18,"pattern":6,"mane":1,"eyes":7,"finish":"normal"},"stats":HorseStats.BASE.duplicate()}
static func receipt()->Dictionary:
 return {"rule":1,"horse":HORSE,"object":"wind_compass","title":"Brújula del Viento"}
static func valid_receipts(value:Variant)->bool:
 if not value is Dictionary:return false
 return value.is_empty() or (value.size()==1 and value.get(RECEIPT)==receipt())
static func has_temper(h:Dictionary)->bool:return h.get("cup_temper195","")==TEMPER
static func crossing_duration(h:Dictionary)->float:return .52 if has_temper(h) else .65
static func claim(collection:HorseCollection)->Dictionary:
 if collection.cup_rewards195.has(RECEIPT):return {"ok":true,"already":true}
 if not collection.known_record(HORSE).is_empty():return {"ok":false,"reason":"horse_id_conflict"}
 collection.horses.append(horse());collection.cup_rewards195[RECEIPT]=receipt()
 return {"ok":true,"already":false}
