extends GutTest
func test_all_second_campaign_levels_have_ten_unique_bulls_and_valid_links():
 assert_eq(LevelCatalog.MAX_LEVEL,40)
 for n in range(21,41):
  var data:=LevelCatalog.get_level(n);assert_eq(data.bull_count,10);assert_between(data.time_limit_seconds,240.,480.)
  var ids:Array=[]
  for i in data.pens.size():
   var pen:Dictionary=data.pens[i];ids.append_array(pen.bull_indices)
   for link in pen.get("opens_pen_indices",[]):assert_between(link,0,data.pens.size()-1);assert_ne(link,i)
  ids.sort();assert_eq(ids,range(10));assert_gt(EquipmentCatalog.REWARDS.get(n,0),0)
func test_old_mastery_stays_100_and_campaigns_do_not_mix_half_completions():
 var h:Dictionary={"completed_levels":range(1,21)};assert_eq(HorseMastery.percent(h),100.);assert_eq(HorseMastery.campaign_percent173(h,2),0.)
 h.completed_levels=range(21,41);assert_eq(HorseMastery.percent(h),100.);assert_eq(HorseMastery.campaign_percent173(h,1),0.)
 h.completed_levels=range(1,11)+range(21,31);assert_eq(HorseMastery.percent(h),50.)
func test_keys_cannot_be_bought_or_repeated_and_restore_persists_consumption():
 var c:=HorseCollection.new();c.seed_trial();assert_eq(GalaxyKeys173.available(c,19),[]);assert_eq(GalaxyKeys173.available(c,20),[20])
 assert_true(GalaxyKeys173.consume(c,20));assert_eq(GalaxyKeys173.available(c,39),[]);assert_false(GalaxyKeys173.consume(c,39));assert_eq(GalaxyKeys173.available(c,40),[40])
 var copy:=HorseCollection.new();assert_true(copy.restore(c.export_state()));assert_eq(GalaxyKeys173.available(copy,40),[40]);assert_true(GalaxyKeys173.consume(copy,40));assert_false(GalaxyKeys173.consume(copy,40))
func test_legacy_horses_kept_and_first_earned_key_recognizes_previous_acquisition():
 var c:=HorseCollection.new();c.seed_trial();var old:=HorseMarket.buy(c,{"traits":{"coat":3,"pattern":6,"mane":5,"finish":"galaxy"}});var before:=old.duplicate(true)
 c.galaxy_rule173=0;GalaxyKeys173.migrate(c,20);assert_eq(c.find(old.id),before);assert_eq(GalaxyKeys173.available(c,20),[]);assert_eq(GalaxyKeys173.available(c,40),[40])
func test_new_mixed_crosses_do_not_create_galaxy_but_pure_birth_does():
 var c:=HorseCollection.new();c.seed_trial();var a:=HorseMarket.buy(c,{"traits":{"coat":3,"pattern":6,"mane":5,"finish":"galaxy"}});var b:=HorseMarket.buy(c,{"traits":{"coat":4,"pattern":6,"mane":5,"finish":"galaxy"}})
 assert_eq(c.preview("original",a.id,{"finish":1}).finish,"normal");var mixed:=c.breed("original",a.id,{"finish":1});assert_false(GalaxyPure143.is_pure(mixed));assert_eq(mixed.traits.finish,"normal")
 var child:=c.breed(a.id,b.id,{});assert_eq(child.traits.finish,"galaxy");assert_true(GalaxyPure143.is_pure(child));assert_eq(child.stage,"foal")
func test_no_random_galaxy_offers_before20_and_all_future_purchases_require_key():
 for n in range(1,41):
  var offers:=HorseMarket.offers(n);assert_eq(offers.filter(func(h):return h.traits.finish=="galaxy").size(),0 if n<20 else (2 if n>=40 else 1))
  if n>=20:
   var c:=HorseCollection.new();c.seed_trial();assert_true(GalaxyKeys173.consume(c,n));if n>=40:assert_true(GalaxyKeys173.consume(c,n))
   assert_false(HorseMarket.available(c,offers[5],n))
func test_key_purchase_rejects_forgery_and_sale_never_restores_key():
 var c:=HorseCollection.new();c.seed_trial();var offer:Dictionary=HorseMarket.offers(40)[4];var forged:=offer.duplicate(true);forged.galaxy_key173=20
 assert_false(HorseMarket.available(c,forged,40));assert_true(GalaxyKeys173.consume(c,40,40));var h:=HorseMarket.buy(c,offer);assert_false(h.is_empty())
 assert_true(HorseMarket.sell(c,h.id));assert_eq(GalaxyKeys173.available(c,40),[20]);assert_false(GalaxyKeys173.consume(c,40,40));assert_true(GalaxyKeys173.consume(c,40,20));assert_eq(GalaxyKeys173.available(c,40),[])
func test_legacy_sold_galaxy_counts_after_cold_reload():
 var c:=HorseCollection.new();c.seed_trial();var old:=HorseMarket.buy(c,{"traits":{"coat":3,"pattern":6,"mane":5,"finish":"galaxy"}});c.ancestors.append(old.duplicate(true));c.horses.erase(old)
 c.galaxy_rule173=0;var state:=c.export_state();state.erase("galaxy_rule173");var copy:=HorseCollection.new();assert_true(copy.restore(state));GalaxyKeys173.migrate(copy,20);assert_eq(GalaxyKeys173.available(copy,40),[40]);assert_eq(copy.ancestors[0],old)

func test_galaxy20_offer_keeps_same_appearance_as_more_levels_are_completed():
 var first:Dictionary=HorseMarket.offers(20)[5]
 for n in range(21,41):assert_eq(HorseMarket.offers(n)[5],first)

func test_invalid_key_payload_fails_without_changing_collection():
 var c:=HorseCollection.new();c.seed_trial();var before:=c.export_state()
 for invalid in [[true],["20"],[21],{"key":20}]:
  var state:=before.duplicate(true);state.galaxy_keys173=invalid;assert_false(c.restore(state));assert_eq(c.export_state(),before)
 for invalid in [-1,2,true,"1"]:
  var state:=before.duplicate(true);state.galaxy_rule173=invalid;assert_false(c.restore(state));assert_eq(c.export_state(),before)
