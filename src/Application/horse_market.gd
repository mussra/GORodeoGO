class_name HorseMarket
extends RefCounted
## Design tiers, not measured occurrence probabilities. No changes to breeding.
const COAT_SCORES=[0,0,1,1,1,1,2,2,2,1,0,0,1,1,2,2,2,2,1,2]
const PATTERN_SCORES=[0,0,1,1,1,2,2,2,2,2,2,2]
const BUY_PRICES=[250,600,1400,3200,7000]
const SELL_PERCENT=40
static func tier(h:Dictionary)->int:
 var t:Dictionary=h.traits
 var score:int=COAT_SCORES[int(t.coat)]+PATTERN_SCORES[int(t.pattern)]
 if int(t.mane)==5:score+=2
 var eyes:int=HorseCollection.eye_index(t)
 if eyes>=20:score+=2
 if t.get("finish","normal")=="galaxy":score+=4
 return clampi(int(score/2),0,4)
static func buy_price(h:Dictionary)->int:
 return BUY_PRICES[tier(h)]+(200 if HorseJump.capable(h) else 0)
static func sell_price(h:Dictionary)->int:

 return int(mini(buy_price(h),int(h.get("purchase_price",buy_price(h))))*SELL_PERCENT/100)
static func can_sell(c:HorseCollection,id:String)->bool:
 return id!="original" and id!=c.selected and c.horses.size()>1 and c.is_adult(id) and sell_price(c.find(id))>0
static func buy(c:HorseCollection,offer:Dictionary)->Dictionary:
 if not c.valid_traits(offer.get("traits")):return {}
 var n:int=c.next_id
 while not c.known_record("market_%d"%n).is_empty():n+=1
 c.next_id=n+1
 var h:Dictionary={"id":"market_%d"%n,"name":c.suggest_name(offer.traits),"parents":[],"stage":"adult","origin":"purchased","traits":offer.traits.duplicate(true),"can_jump":HorseJump.capable(offer),"purchase_price":buy_price(offer)}
 c.horses.append(h);return h
static func sell(c:HorseCollection,id:String)->bool:
 if not can_sell(c,id):return false
 var record:Dictionary=c.find(id).duplicate(true);record["sold"]=true
 for i in range(c.horses.size()):
  if c.horses[i].id==id:c.horses.remove_at(i);break
 c.ancestors.append(record);return true

## Six one-off offers per reached level. Stable across reloads; no wall clock rerolls.
static func _normal_offers173(progress:int)->Array[Dictionary]:
 var result:Array[Dictionary]=[];var rng:=RandomNumberGenerator.new();rng.seed=91073+progress*197
 var cap:int=mini(4,int(progress/4));var attempts:int=0
 while result.size()<6 and attempts<100000:
  attempts+=1
  var h:Dictionary={"traits":{"coat":rng.randi_range(0,19),"pattern":rng.randi_range(0,9),"mane":rng.randi_range(0,5),"eyes":rng.randi_range(0,21),"finish":"normal"},"can_jump":progress>=3 and rng.randf()<.3}
  # Higher tiers only enter as progress permits. Within unlocked pool, high tiers remain less offered.
  var rank:int=tier(h)
  if rank>cap or rng.randf()>pow(.45,rank):continue
  h["offer_id"]="offer_%d_%d"%[progress,result.size()];h["name"]=HorseCollection.COATS[h.traits.coat];result.append(h)
 return result
static func offers(progress:int)->Array[Dictionary]:
 var result:=_normal_offers173(progress)
 if progress>=20:
  result[5]=_normal_offers173(20)[5]
  result[5].traits["finish"]="galaxy"
  result[5]["galaxy_key173"]=20;result[5].offer_id="galaxy_key_20"
 if progress>=40:
  result[4]=_normal_offers173(40)[4]
  result[4].traits["finish"]="galaxy";result[4]["galaxy_key173"]=40;result[4].offer_id="galaxy_key_40"
 return result
static func available(c:HorseCollection,offer:Dictionary,progress:int)->bool:
 if offer.get("traits",{}).get("finish","")=="galaxy" and not GalaxyKeys173.available(c,progress).has(int(offer.get("galaxy_key173",0))):return false
 for candidate in offers(progress):
  if candidate.get("galaxy_key173",0)==offer.get("galaxy_key173",0) and candidate.offer_id==offer.get("offer_id","") and not c.bought_offers.has(candidate.offer_id) and candidate.traits==offer.get("traits",{}) and candidate.can_jump==offer.get("can_jump",false):return true
 return false
