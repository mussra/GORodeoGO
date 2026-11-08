class_name PackLeader
extends RefCounted
## "Lider de manada" (Ant 8-nov 2026 13:33; nombre neutro, cualquier caballo o
## yegua puede ganarlo): un caballo CRIADO en el rancho con 3+ generaciones
## registradas y rasgos visibles fijados (mismo pelaje, patron y crin que sus
## dos padres) lidera a los salvajes de su tipo: no huyen al asustarse y su
## confianza empieza en LEADER_START_PROGRESS. Titulo: clave i18n LEADER_TITLE.

const MIN_GENERATION: int = 3

static func _by_id(collection: HorseCollection) -> Dictionary:
	var by_id: Dictionary = {}
	for h in HorseGenealogy.records(collection):
		by_id[h.id] = h
	return by_id

static func is_leader(horse: Dictionary, collection: HorseCollection) -> bool:
	if horse.is_empty() or horse.get("stage", "adult") != "adult":
		return false
	var parents: Array = horse.get("parents", [])
	if parents.size() < 2:
		return false
	var by_id: Dictionary = _by_id(collection)
	if HorseGenealogy.generation(horse.id, by_id, {}, {}) < MIN_GENERATION:
		return false
	for key in ["coat", "pattern", "mane"]:
		var v: int = int(horse.traits.get(key, -1))
		for p in parents:
			var ph: Dictionary = by_id.get(p, {})
			if ph.is_empty() or int(ph.get("traits", {}).get(key, -2)) != v:
				return false
	return true
