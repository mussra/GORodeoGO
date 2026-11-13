extends GutTest
func collection()->HorseCollection:
 var c:=HorseCollection.new();c.seed_trial();var other:=HorseMarket.buy(c,HorseMarket.offers(1)[0]);c.breed("original",other.id,{});return c
func test_only_foals_grow_ten_future_sessions_and_mature_preserves_identity():
 var c:=collection();var h:Dictionary=c.horses[-1];var original:Dictionary=c.find("original").duplicate(true);var birth:=h.duplicate(true)
 assert_false(FoalGrowth174.mature(c,h.id))
 for n in range(1,11):assert_eq(FoalGrowth174.advance(c),1);assert_eq(FoalGrowth174.sessions(h),n)
 assert_eq(FoalGrowth174.advance(c),0);assert_true(FoalGrowth174.ready(h));assert_true(FoalGrowth174.mature(c,h.id));assert_eq(h.id,birth.id);assert_eq(h.parents,birth.parents);assert_eq(h.traits,birth.traits);assert_eq(c.find("original"),original);assert_false(FoalGrowth174.mature(c,h.id))
func test_existing_foal_starts_zero_persists_and_invalid_data_rejected():
 var c:=collection();var h:Dictionary=c.horses[-1];assert_eq(FoalGrowth174.sessions(h),0);FoalGrowth174.advance(c);var state:=c.export_state();var copy:=HorseCollection.new();assert_true(copy.restore(state));assert_eq(FoalGrowth174.sessions(copy.find(h.id)),1)
 for bad in [-1,11,true,"5"]:
  var invalid:=state.duplicate(true);invalid.horses[-1].growth174=bad;assert_false(copy.restore(invalid));assert_eq(copy.export_state(),state)
