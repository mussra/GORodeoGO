class_name EquipmentPoints
extends RefCounted

## Unwired candidate. The caller supplies reviewed reward/price definitions.
## No default balance curve, no persistence, no real-money purchases.
var balance:int=0
var owned:Array[String]=[]
var equipped:Dictionary={}
var _rewarded_results:Dictionary={}

func reward_completed_level(level:int,result_id:String,rewards:Dictionary)->int:
	if result_id.is_empty() or _rewarded_results.has(result_id):return 0
	var value:Variant=rewards.get(level,0)
	if typeof(value)!=TYPE_INT or value<=0:return 0
	_rewarded_results[result_id]=true
	balance+=value
	return value

func can_buy(item_id:String,catalog:Dictionary)->bool:
	if owned.has(item_id) or not catalog.has(item_id):return false
	var item:Dictionary=catalog[item_id]
	var price:Variant=item.get("price",-1)
	return typeof(price)==TYPE_INT and price>=0 and balance>=price and (not item.has("requires") or owned.has(item["requires"]))

func buy(item_id:String,catalog:Dictionary)->bool:
	if not can_buy(item_id,catalog):return false
	balance-=catalog[item_id]["price"]
	owned.append(item_id)
	return true

func equip(item_id:String,catalog:Dictionary)->bool:
	if not catalog.has(item_id):return false
	var item:Dictionary=catalog[item_id]
	if not owned.has(item_id) and not item.get("base",false):return false
	var slot:String=item.get("slot","")
	if slot.is_empty():return false
	equipped[slot]=item_id
	return true
