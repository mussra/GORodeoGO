class_name HorseFilters
extends RefCounted
## Filtros del atlas (Ant 8-nov 19:13): >1000 entradas y tarde o temprano
## unicornios, así que las propiedades filtrables son DATOS, no código fijo:
## añadir una propiedad futura (p. ej. especie caballo/unicornio) es una
## entrada más en properties(). Un filtro activo es {id: valor} y una entrada
## pasa si cumple TODOS los filtros activos (AND).
## Cada entrada del atlas es {"horse": {...}, "owned": bool}.
## Ojo: las entradas no conseguidas solo varían coat/pattern/mane (el combo
## del atlas no genera ojos ni finish), así que esas claves no se ofrecen
## hasta que las entradas las lleven.

static func _trait_values(names: Array) -> Array:
	var out: Array = []
	for i in names.size():
		out.append({"value": i, "label": String(names[i])})
	return out

static func _trait(key: String) -> Callable:
	return func(entry: Dictionary, v) -> bool: return entry.horse.get("traits", {}).get(key) == v

static func properties() -> Array:
	return [
		{"id": "coat", "label": "FILTER_COAT", "values": _trait_values(HorseCollection.COATS), "matches": _trait("coat")},
		{"id": "pattern", "label": "FILTER_PATTERN", "values": _trait_values(HorseCollection.PATTERNS), "matches": _trait("pattern")},
		{"id": "mane", "label": "FILTER_MANE", "values": _trait_values(HorseCollection.MANES), "matches": _trait("mane")},
		{"id": "rarity", "label": "FILTER_RARITY", "values": _trait_values(HorseCollection.RARITIES), "matches": func(entry: Dictionary, v) -> bool: return (4 if entry.horse.get("species", "")=="unicorn" else HorseMarket.tier(entry.horse)) == int(v)},
		{"id": "owned", "label": "FILTER_OWNED", "values": [{"value": true, "label": "FILTER_OWNED_YES"}, {"value": false, "label": "FILTER_OWNED_NO"}], "matches": func(entry: Dictionary, v) -> bool: return bool(entry.owned) == bool(v)},
	]

static func apply(entries: Array[Dictionary], active: Dictionary) -> Array[Dictionary]:
	if active.is_empty():
		return entries
	var props: Dictionary = {}
	for p in properties():
		props[p.id] = p
	var out: Array[Dictionary] = []
	for entry in entries:
		var ok := true
		for id in active:
			var p: Dictionary = props.get(id, {})
			if p.is_empty():
				continue  # propiedad desconocida (p. ej. de una versión futura): se ignora
			if not (p.matches as Callable).call(entry, active[id]):
				ok = false
				break
		if ok:
			out.append(entry)
	return out
