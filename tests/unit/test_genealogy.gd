extends GutTest
func test_all_roots_and_connected_generations()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();var child:=c.breed("trial_a","trial_b",{});c.mature_trial(child.id);var grand:=c.breed(child.id,"original",{})
 var p:=HorseGenealogy.layout(c);assert_eq(p.size(),5);assert_gt(p[child.id].y,p.trial_a.y);assert_gt(p[grand.id].y,p[child.id].y)
func test_filters_do_not_mutate_collection()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();var before:=c.export_state()
 assert_true(HorseGenealogy.matches(c.find("trial_a"),"AZUL",{"coat":3}));assert_false(HorseGenealogy.matches(c.find("trial_a"),"",{"coat":10}));assert_eq(c.export_state(),before)
func test_unknown_breed_not_inferred_from_color()->void:
 var c:=HorseCollection.new();c.seed_trial();assert_false(c.find("original").has("breed"));assert_eq(HorseGenealogy.lineage(c.find("original")),TranslationServer.translate("GEN_UNKNOWN"))
func test_external_ancestor_can_connect_owned_child_without_becoming_owned()->void:
 var c:=HorseCollection.new();c.seed_trial();var a:Dictionary=c.find("original").duplicate(true);a.id="external";a.name="Known ancestor"
 assert_true(c.register_ancestor(a));assert_true(c.find("external").is_empty());assert_false(c.known_record("external").is_empty())
 var v:=c.export_state();var child:Dictionary=c.find("original").duplicate(true);child.id="purchased";child.name="Bought";child.parents=["original","external"];child.origin="purchased";v.horses.append(child)
 assert_true(c.restore(v));assert_eq(HorseGenealogy.records(c).size(),3);assert_eq(c.find("purchased").parents,["original","external"])
 var d:=HorseCollection.new();assert_true(d.restore(c.export_state()));assert_eq(d.ancestors,c.ancestors)
func test_invalid_ancestor_cycle_and_duplicate_rejected_atomically()->void:
 var c:=HorseCollection.new();c.seed_trial();var before:=c.export_state();var a:Dictionary=c.find("original").duplicate(true);a.id="bad";a.parents=["bad","bad"]
 assert_false(c.register_ancestor(a));assert_eq(c.export_state(),before)
