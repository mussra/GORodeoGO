extends GutTest
func test_five_variants_hidden_and_cosmetic_galaxy_does_not_unlock():
 var h={"id":"old_galaxy","traits":{"coat":3,"pattern":0,"mane":0,"finish":"galaxy"}}
 var entries=UnicornAtlas.entries([h]);assert_eq(entries.size(),5)
 for e in entries:assert_true(e.silhouette);assert_false(e.owned)
func test_reveals_only_owned_explicit_species_variant_without_mutation():
 var h={"id":"unicorn_pink","species":"unicorn","unicorn_variant":"pink","traits":{"coat":3,"pattern":0,"mane":0}}
 var before=h.duplicate(true);var entries=UnicornAtlas.entries([h]);assert_eq(h,before)
 for e in entries:
  assert_eq(e.owned,e.variant=="pink");assert_eq(e.silhouette,e.variant!="pink")
  if e.owned:assert_eq(e.horse,h)

func test_sold_unicorn_remains_discovered_when_records_passed():
 var c=HorseCollection.new();c.seed_trial();c.add_trial_parents();c.find("trial_b")["species"]="unicorn";c.find("trial_b")["unicorn_variant"]="black"
 assert_true(HorseMarket.sell(c,"trial_b"))
 var entries=UnicornAtlas.entries(HorseGenealogy.records(c))
 assert_false(entries[4].silhouette)

func test_normal_galaxy_remains_obtainable_but_is_not_unicorn():
 var c=HorseCollection.new();c.seed_trial();c.add_trial_parents();c.find("trial_a").traits.finish="galaxy";c.find("trial_b").traits.finish="galaxy"
 var child=c.breed("trial_a","trial_b",{"finish":1});assert_eq(child.traits.finish,"galaxy")
 assert_false(child.has("species"))
 var entries=UnicornAtlas.entries(c.horses)
 for e in entries:assert_true(e.silhouette)
 var found:bool=false
 for progress in range(16,101):
  for offer in HorseMarket.offers(progress):
   if offer.traits.finish=="galaxy":found=true
 assert_true(found)
