extends SceneTree
func _initialize():
 var total:float=0;var reward:int=0;var rows:Array=[]
 for n in range(1,21):
  var t:float=LevelCatalog.get_level(n).time_limit_seconds;total+=t;reward+=int(EquipmentCatalog.REWARDS.get(n,0));rows.append({"level":n,"limit_seconds":t,"reward":EquipmentCatalog.REWARDS.get(n,0)})
 var offers:Array=[]
 for offer in HorseMarket.offers(20):
  if offer.traits.get("finish","")=="galaxy":offers.append({"id":offer.offer_id,"price":HorseMarket.buy_price(offer)})
 print("JOURNEY157_RULES ",JSON.stringify({"levels":rows,"total_seconds":total,"total_rewards":reward,"galaxy_offers20":offers}))
 var data:=CountryRoute146.plan(752026)
 for id in ["approach","upstream"]:
  var path:PackedVector2Array=data[id];var distance:float=0
  for n in range(1,path.size()):distance+=path[n].distance_to(path[n-1])
  print("JOURNEY157_PATH ",id," distance=",distance," seconds_at187=",distance/187.," seconds_at260=",distance/260.)
 quit()
