extends GutTest
func test_bounded_variants_and_extra_traits_have_exact_ownership()->void:
 var base:Dictionary={"coat":10,"pattern":1,"mane":2,"eyes":0,"finish":"normal"}
 var variants:Array=HorseAtlas.variants(base,{},[])
 assert_gt(variants.size(),1);assert_lte(variants.size(),21)
 var t:Dictionary=variants[1].horse.traits.duplicate(true)
 var horses:Array=[{"id":"mine","traits":t}]
 assert_true(HorseAtlas.variants(base,{},horses)[0].owned)
 var altered:Array=HorseAtlas.variants(base,{"eyes":3,"legs":0},horses)
 for entry in altered:
  assert_false(entry.owned);assert_eq(entry.horse.traits.eyes,3);assert_eq(entry.horse.traits.legs,0)
 assert_eq(base.eyes,0);assert_false(base.has("spots"))
func test_smooth_family_does_not_multiply_invisible_spots()->void:
 var base:Dictionary={"coat":3,"pattern":0,"mane":0}
 assert_eq(HorseAtlas.variants(base,{},[]).size(),1)
func test_original_and_explicit_colors_keep_separate_signatures()->void:
 var a:Dictionary={"coat":10,"pattern":1,"mane":0}
 var b:Dictionary=a.duplicate();b.spots=1
 assert_ne(HorseAtlas.signature(a),HorseAtlas.signature(b))
 assert_eq(HorseAtlas.properties().size(),3)
func test_matching_requires_finish_and_eyes_legs_spots_not_only_family()->void:
 var t:Dictionary={"coat":10,"pattern":1,"mane":2,"eyes":3,"spots":3,"legs":0,"finish":"normal"}
 var horses:Array=[{"id":"a","traits":t.duplicate(true)}]
 assert_false(HorseAtlas.owned(t,horses).is_empty())
 for key in ["eyes","spots","legs"]:
  var other:Dictionary=t.duplicate(true);other[key]=4
  assert_true(HorseAtlas.owned(other,horses).is_empty())
 var galaxy:Dictionary=t.duplicate(true);galaxy.finish="galaxy"
 assert_true(HorseAtlas.owned(galaxy,horses).is_empty())
func test_contrast_filter_never_offers_same_coat_or_invisible_spots()->void:
 assert_false(HorseAtlas.contrast_ok({"coat":3,"pattern":1,"spots":3}))
 assert_false(HorseAtlas.contrast_ok({"coat":3,"pattern":0,"spots":5}))
 assert_true(HorseAtlas.contrast_ok({"coat":3,"pattern":1,"spots":1}))
