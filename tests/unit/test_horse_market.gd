extends GutTest
func test_prices_monotone_and_no_instant_resale_profit()->void:
 for coat in range(20):
  for pattern in range(10):
   for mane in range(6):
    var h:Dictionary={"id":"offered","traits":{"coat":coat,"pattern":pattern,"mane":mane}}
    assert_gte(HorseMarket.tier(h),0);assert_lte(HorseMarket.tier(h),4);assert_lt(HorseMarket.sell_price(h),HorseMarket.buy_price(h))
func test_bought_sold_parent_keeps_identity_and_roundtrips_with_descendant()->void:
 var c:=HorseCollection.new();c.seed_trial();var h:=HorseMarket.buy(c,{"traits":{"coat":3,"pattern":6,"mane":5}});var child:=c.breed("original",h.id,{})
 assert_true(HorseMarket.sell(c,h.id));assert_true(c.find(h.id).is_empty());assert_eq(c.known_record(h.id).origin,"purchased");assert_eq(c.find(child.id).parents,["original",h.id])
 var restored:=HorseCollection.new();assert_true(restored.restore(c.export_state()));assert_eq(restored.export_state(),c.export_state());assert_eq(HorseGenealogy.related_paths(restored,child.id).nodes.size(),3)
func test_sale_guards_and_achievement_cannot_mint_duplicate_reward()->void:
 var c:=HorseCollection.new();c.seed_trial();assert_false(HorseMarket.can_sell(c,"original"));assert_false(HorseMarket.can_sell(c,"missing"));var h:=c.grant_achievement(3);c.selected=h.id;assert_false(HorseMarket.can_sell(c,h.id));c.selected="original";assert_true(HorseMarket.sell(c,h.id));assert_true(c.grant_achievement(3).is_empty())
func test_atomic_purchase_and_sale_save_failure()->void:
 var save:Node=get_tree().root.get_node("SaveData");var old_c:HorseCollection=save.horse_collection;var old_points:int=save.equipment_points;var old_path:String=save.save_path;var old_trial:bool=save.trial_session_active
 save.trial_session_active=false;save.horse_collection=HorseCollection.new();save.horse_collection.seed_trial();save.equipment_points=10000;save.save_path="user://missing_market_parent/save.dat"
 var before:Dictionary=save.horse_collection.export_state();assert_false(save.buy_market_horse(HorseMarket.offers(save.highest_level_completed)[0]));assert_eq(save.equipment_points,10000);assert_eq(save.horse_collection.export_state(),before)
 var h:=HorseMarket.buy(save.horse_collection,{"traits":{"coat":0,"pattern":0,"mane":0}});before=save.horse_collection.export_state();assert_false(save.sell_market_horse(h.id));assert_eq(save.equipment_points,10000);assert_eq(save.horse_collection.export_state(),before)
 assert_push_error_count(2)
 save.save_path=old_path;save.equipment_points=old_points;save.horse_collection=old_c;save.trial_session_active=old_trial
func test_successful_trade_persists_and_modes_remain_isolated()->void:
 var save:Node=get_tree().root.get_node("SaveData");var old_c:HorseCollection=save.horse_collection;var old_points:int=save.equipment_points;var old_path:String=save.save_path;var old_trial:bool=save.trial_session_active;var old_debug:bool=save.debug_mode;var old_normal:String=save.normal_mode_path;var old_debug_path:String=save.debug_mode_path
 save.trial_session_active=false;save.debug_mode=false;save.normal_mode_path="user://market-normal-qa.dat";save.debug_mode_path="user://market-debug-qa.dat";DirAccess.remove_absolute(save.normal_mode_path);DirAccess.remove_absolute(save.debug_mode_path);save.save_path=save.normal_mode_path;save.horse_collection=HorseCollection.new();save.horse_collection.seed_trial();save.equipment_points=10000
 var offer:Dictionary=HorseMarket.offers(save.highest_level_completed)[0];var cost:int=HorseMarket.buy_price(offer);assert_true(save.buy_market_horse(offer));var id:String=save.horse_collection.horses[-1].id;assert_eq(save.equipment_points,10000-cost)
 var cf:=ConfigFile.new();assert_eq(cf.load(save.normal_mode_path),OK);var restored:=HorseCollection.new();assert_true(restored.restore(cf.get_value("horses_trial","state")));assert_false(restored.find(id).is_empty());assert_eq(cf.get_value("equipment","points"),10000-cost)
 assert_true(save.switch_mode(true));assert_true(save.horse_collection.find(id).is_empty());save.equipment_points=999;assert_true(save.save_progress());assert_true(save.switch_mode(false));assert_false(save.horse_collection.find(id).is_empty());assert_eq(save.equipment_points,10000-cost)
 var payout:int=HorseMarket.sell_price(save.horse_collection.find(id));assert_true(save.sell_market_horse(id));assert_eq(save.equipment_points,10000-cost+payout);assert_eq(cf.load(save.normal_mode_path),OK);assert_true(restored.restore(cf.get_value("horses_trial","state")));assert_true(restored.find(id).is_empty());assert_false(restored.known_record(id).is_empty())
 DirAccess.remove_absolute(save.normal_mode_path);DirAccess.remove_absolute(save.debug_mode_path);save.normal_mode_path=old_normal;save.debug_mode_path=old_debug_path;save.debug_mode=old_debug;save.save_path=old_path;save.equipment_points=old_points;save.horse_collection=old_c;save.trial_session_active=old_trial
func test_limited_offers_are_stable_tier_gated_and_one_off()->void:
 for level in range(21):
  var offers:Array[Dictionary]=HorseMarket.offers(level);assert_eq(offers.size(),6);assert_eq(offers,HorseMarket.offers(level))
  for offer in offers:assert_lte(HorseMarket.tier(offer),mini(4,int(level/4)))
 var c:=HorseCollection.new();c.seed_trial();var offer:Dictionary=HorseMarket.offers(0)[0];assert_true(HorseMarket.available(c,offer,0));c.bought_offers.append(offer.offer_id);assert_false(HorseMarket.available(c,offer,0));assert_false(HorseMarket.available(c,offer,1))
func test_birth_requires_victory_credit_in_normal_but_debug_is_free()->void:
 var save:Node=get_tree().root.get_node("SaveData");var old_c:HorseCollection=save.horse_collection;var old_debug:bool=save.debug_mode;var old_trial:bool=save.trial_session_active;var old_path:String=save.save_path
 save.trial_session_active=false;save.debug_mode=false;save.save_path="user://market-birth-qa.dat";save.horse_collection=HorseCollection.new();save.horse_collection.seed_trial();save.horse_collection.add_trial_parents()
 assert_true(save.breed_horses("original","trial_a",{}).is_empty());save.horse_collection.birth_credits=1;var child:Dictionary=save.breed_horses("original","trial_a",{});assert_false(child.is_empty());assert_eq(save.horse_collection.birth_credits,0);assert_true(save.breed_horses("original","trial_a",{}).is_empty());save.horse_collection.mature_trial(child.id);assert_gt(HorseMarket.sell_price(child),0)
 save.debug_mode=true;assert_false(save.breed_horses("original","trial_a",{}).is_empty());assert_eq(save.horse_collection.birth_credits,0)
 DirAccess.remove_absolute(save.save_path);save.horse_collection=old_c;save.debug_mode=old_debug;save.trial_session_active=old_trial;save.save_path=old_path

func test_victories_grant_births_and_failed_save_rolls_them_back()->void:
 var sut=load("res://src/Application/save_data.gd").new();sut.save_path="user://market-victory-qa.dat";sut.points_legacy_credit_applied=true;sut.horse_collection.seed_trial()
 assert_eq(sut.horse_collection.birth_credits,0);assert_gt(sut.record_victory(1),0);assert_eq(sut.horse_collection.birth_credits,1);assert_gt(sut.record_victory(1),0);assert_eq(sut.horse_collection.birth_credits,2);sut.load_progress();assert_eq(sut.horse_collection.birth_credits,2)
 sut.save_path="user://market-missing-parent/victory.dat";assert_eq(sut.record_victory(2),0);assert_eq(sut.horse_collection.birth_credits,2);assert_push_error_count(1);sut.free();DirAccess.remove_absolute("user://market-victory-qa.dat")
func test_exhausted_offers_stay_exhausted_on_reload_and_no_direct_atlas_bypass()->void:
 var c:=HorseCollection.new();c.seed_trial()
 for offer in HorseMarket.offers(8):c.bought_offers.append(offer.offer_id)
 var d:=HorseCollection.new();assert_true(d.restore(c.export_state()))
 for offer in HorseMarket.offers(8):assert_false(HorseMarket.available(d,offer,8))
 assert_false(HorseMarket.available(d,{"traits":{"coat":0,"pattern":0,"mane":0}},8));assert_true(HorseMarket.available(d,HorseMarket.offers(9)[0],9))
