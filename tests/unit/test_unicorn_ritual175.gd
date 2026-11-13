extends GutTest
func family()->HorseCollection:
 var c:=HorseCollection.new();c.seed_trial()
 var a:=HorseMarket.buy(c,{"traits":{"coat":3,"pattern":6,"mane":3,"eyes":3,"finish":"galaxy"}})
 var b:=HorseMarket.buy(c,{"traits":{"coat":3,"pattern":6,"mane":3,"eyes":3,"finish":"galaxy"}})
 var h:=c.breed(a.id,b.id,{});h.stage="adult";h.completed_levels=range(1,21);c.selected=h.id;return c
func test_complete_pure_master_at_source_is_eligible_but_never_converts():
 var c:=family();var before:=c.export_state();var data:=CountryRoute146.plan(752026);var result:=UnicornRitual175.prepare(c,c.selected,CountryRoute146.ID,data.sites.source,data)
 assert_true(result.eligible);assert_false(result.visual_ready);assert_false(result.effect_enabled);assert_eq(result.ancestry.variant,"blue");assert_eq(c.export_state(),before)
func test_each_requirement_explains_missing_and_does_not_guess_genealogy():
 var c:=family();var h:=c.find(c.selected);var data:=CountryRoute146.plan(752026)
 h.stage="foal";h.completed_levels=[];h.erase("galaxy_birth143")
 var result:=UnicornRitual175.prepare(c,c.selected,"frontier",Vector2.ZERO,data);assert_false(result.eligible);assert_eq(result.missing.size(),4)
 assert_false(UnicornRitual175.prepare(c,"absent",CountryRoute146.ID,data.sites.source,data).eligible)
func test_ancestry_is_unique_order_independent_and_sold_parents_still_count():
 var c:=family();var id:String=c.selected;var before:=UnicornRitual175.variant(c,id)
 c.horses.reverse();assert_eq(UnicornRitual175.variant(c,id),before)
 var parent:String=c.find(id).parents[0];assert_true(HorseMarket.sell(c,parent));assert_eq(UnicornRitual175.variant(c,id),before)
 var p:String=c.find(id).parents[1];c.known_record(p).parents=[parent,"original"]
 var graph:=UnicornRitual175.ancestry(c,id);assert_eq(graph.entries.size(),3)
 var shared:Array=graph.entries.filter(func(e):return e.id==parent);assert_eq(shared.size(),1);assert_eq(shared[0].distance,1)
func test_missing_parent_and_cycles_are_rejected_without_recursion_or_mutation():
 var c:=family();var h:=c.find(c.selected);var parent:String=h.parents[0];c.known_record(parent).parents=["missing","original"];assert_eq(UnicornRitual175.variant(c,h.id),{})
 c.known_record(parent).parents=[h.id,"original"];assert_eq(UnicornRitual175.variant(c,h.id),{})
func test_deeper_ancestors_change_scores_without_renaming_id_rerolls():
 var c:=family();var h:=c.find(c.selected);var before:=UnicornRitual175.variant(c,h.id)
 var ancestor:=HorseMarket.buy(c,{"traits":{"coat":4,"pattern":0,"mane":3,"eyes":3,"finish":"normal"}})
 c.known_record(h.parents[0]).parents=["original",ancestor.id]
 var after:=UnicornRitual175.variant(c,h.id);assert_ne(after.scores,before.scores);assert_eq(after.ancestors.size(),4)
 var state:=c.export_state();var copy:=HorseCollection.new();assert_true(copy.restore(state));assert_eq(UnicornRitual175.variant(copy,h.id),after)
func test_source_water_and_wrong_country_fail_even_for_eligible_master():
 var c:=family();var data:=CountryRoute146.plan(752026)
 assert_false(UnicornRitual175.prepare(c,c.selected,"wrong",data.sites.source,data).eligible)
 assert_false(UnicornRitual175.prepare(c,c.selected,CountryRoute146.ID,data.source,data).eligible)
 assert_false(UnicornRitual175.prepare(c,c.selected,CountryRoute146.ID,Vector2(INF,0),data).eligible)
func test_rainbow_mane_is_not_silently_counted_as_red_mane():
 var c:=family();var h:=c.find(c.selected)
 for id in h.parents:c.known_record(id).traits.mane=5
 var rainbow:=UnicornRitual175.variant(c,h.id)
 for id in h.parents:c.known_record(id).traits.mane=4
 var red:=UnicornRitual175.variant(c,h.id);assert_ne(rainbow.scores,red.scores)
func test_ancestry_walk_has_no_short_generation_cutoff_and_rejects_nonroot_cycle():
 var c:=family();var id:String=c.selected;var tail:String=c.find(id).parents[0]
 for i in 40:
  var a:=HorseMarket.buy(c,HorseMarket.offers(1)[0]);var b:=HorseMarket.buy(c,HorseMarket.offers(1)[1]);c.known_record(tail).parents=[a.id,b.id];tail=a.id
 var result:=UnicornRitual175.ancestry(c,id);assert_eq(result.entries.size(),82);assert_gt(result.entries.map(func(e):return e.distance).max(),40)
 c.known_record(tail).parents=[c.find(id).parents[0],"original"];assert_eq(UnicornRitual175.ancestry(c,id),{})
func test_exact_source_distance_uses_walkable_bank_not_water_center():
 var c:=family();var data:=CountryRoute146.plan(752026)
 assert_true(UnicornRitual175.prepare(c,c.selected,CountryRoute146.ID,data.sites.source+Vector2(120,0),data).eligible)
 assert_false(UnicornRitual175.prepare(c,c.selected,CountryRoute146.ID,data.sites.source+Vector2(120.01,0),data).eligible)
