class_name WorldLivestock104
extends RefCounted
## Provisional game economy, not real money. Keep existing capture reward.
const PIG_SALE_PRICE:int=40
static func valid_ids(raw:Variant)->Array[String]:
 var out:Array[String]=[];var seen:Dictionary={}
 if raw is Array or raw is PackedStringArray:
  for id in raw:
   if id is String and not id.is_empty() and not seen.has(id):seen[id]=true;out.append(id)
 return out
static func available(captured:Array,sold:int)->int:return maxi(0,captured.size()-sold)
static func quote(count:int,unit_price:int=PIG_SALE_PRICE)->Dictionary:
 return {"count":maxi(0,count),"unit_price":maxi(0,unit_price),"total":maxi(0,count)*maxi(0,unit_price)}
