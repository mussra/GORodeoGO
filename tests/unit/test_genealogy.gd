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
func test_paths_include_complete_ancestors_descendants_not_spouses_or_siblings()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();var child:=c.breed("trial_a","trial_b",{});c.mature_trial(child.id);var sibling:=c.breed("trial_a","trial_b",{});var grand:=c.breed(child.id,"original",{})
 var r:Dictionary=HorseGenealogy.related_paths(c,child.id)
 for id in [child.id,"trial_a","trial_b",grand.id]:assert_true(r.nodes.has(id))
 assert_false(r.nodes.has("original"),"other parent of descendant is not an ancestor");assert_false(r.nodes.has(sibling.id),"siblings are not on ascending or descending paths")
 assert_eq(r.edges.size(),3);assert_false(r.edges.has(["original",grand.id]))
func test_shared_ancestors_all_branches_and_malformed_cycle_terminate()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();var a:=c.breed("trial_a","trial_b",{});c.mature_trial(a.id);var b:=c.breed("trial_a","trial_b",{});c.mature_trial(b.id);var child:=c.breed(a.id,b.id,{})
 var r:Dictionary=HorseGenealogy.related_paths(c,child.id);assert_eq(r.nodes.size(),5);assert_eq(r.edges.size(),6)
 c.find("trial_a").parents=[child.id,"trial_b"]
 r=HorseGenealogy.related_paths(c,child.id);assert_eq(r.nodes.size(),5);assert_lte(r.edges.size(),8)
 assert_true(HorseGenealogy.related_paths(c,"missing").nodes.is_empty())
