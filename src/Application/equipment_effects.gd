class_name EquipmentEffects
extends RefCounted

## Derived gameplay modifiers from the equipment the player owns and has
## equipped (Juanito's saddlery, Ant OK 16-nov-2026 21:46). Single item per
## slot, so reductions never stack between items of the same effect.
## Everything reads SaveData live: equipping mid-session applies on the next
## call (stamina/stun/boost immediately, dodge recharge on next world update).

static func _equipped_item(slot:String)->Dictionary:
	var id:String=str(SaveData.equipment_equipped.get(slot,""))
	if id.is_empty() or not SaveData.equipment_owned.has(id):return {}
	var item:Variant=EquipmentCatalog.ITEMS.get(id,null)
	return item if typeof(item)==TYPE_DICTIONARY and str(item.get("slot",""))==slot and not item.get("blocked",false) else {}

static func equipped_id(slot:String)->String:
	var id:String=str(SaveData.equipment_equipped.get(slot,""))
	return id if not _equipped_item(slot).is_empty() else ""

## Montura de viaje: running stamina drain multiplier (0.95 / 0.90).
static func running_drain_multiplier()->float:
	return clampf(float(_equipped_item("saddle").get("running_drain_mult",1.0)),0.0,1.0)

## Riendas de precisión: dodge recharge time multiplier (0.95 / 0.90).
static func dodge_recharge_multiplier()->float:
	return clampf(float(_equipped_item("reins").get("dodge_recharge_mult",1.0)),0.0,1.0)

## Estribos de equilibrio: stun duration multiplier (0.95 / 0.90).
static func stun_multiplier()->float:
	return clampf(float(_equipped_item("stirrups").get("stun_mult",1.0)),0.0,1.0)

## Espuelas: the equipped spur item, or {} when none. Keys: spur_boost,
## spur_seconds, spur_cooldown, spur_stamina_cost.
static func spurs()->Dictionary:
	return _equipped_item("spurs")

## Cosmetics: appearance only, no gameplay advantage.
static func cosmetic_equipped(slot:String)->bool:
	return not equipped_id(slot).is_empty()
