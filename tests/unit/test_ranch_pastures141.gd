extends GutTest
func test_pagination_rarity_filters_and_non_mutation():
 var c:=HorseCollection.new();c.seed_trial()
 for i in 28:c.horses.append({"id":"r"+str(i),"name":"Caballo "+str(i),"parents":[],"stage":"adult","traits":{"coat":i%20,"pattern":i%12,"mane":i%6,"finish":"normal"}})
 var before:=c.export_state();var seen:Array=[]
 for page_index in 3:
  var page_:=RanchPastures141.page(c,-1,page_index);assert_lte(page_.size(),12)
  for h in page_:assert_false(seen.has(h.id));seen.append(h.id)
 assert_eq(seen.size(),c.horses.size())
 var total:int=0
 for tier in 5:
  var filtered:=RanchPastures141.horses(c,tier);total+=filtered.size()
  for h in filtered:assert_eq(HorseMarket.tier(h),tier)
 assert_eq(total,c.horses.size());assert_eq(c.export_state(),before)
func test_family_includes_known_parents_in_order_without_creating_horses():
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents()
 var child:=c.breed("trial_a","trial_b",{})
 var family:=RanchPastures141.family(c,child.id)
 assert_eq(family.map(func(h):return h.id),["trial_a","trial_b",child.id])
 assert_eq(child.stage,"foal");assert_false(c.is_adult(child.id))
 assert_eq(RanchPastures141.family(c,"missing"),[])
func test_unicorn_and_boundary_pages_follow_existing_atlas_rarity():
 var c:=HorseCollection.new();c.seed_trial();c.horses.append({"id":"u","name":"Unicornio","parents":[],"species":"unicorn","traits":{"coat":10,"pattern":0,"mane":1}})
 assert_eq(RanchPastures141.horses(c,4).map(func(h):return h.id),["u"])
 assert_eq(RanchPastures141.page(c,-1,-3).size(),2);assert_eq(RanchPastures141.page(c,-1,100).size(),2)
 assert_eq(RanchPastures141.page(c,3,100),[])
