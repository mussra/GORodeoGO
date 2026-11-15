extends GutTest
const PATH="user://hat235-test.cfg"
func after_each():DirAccess.remove_absolute(PATH)
func test_new_wardrobe_locks_unowned_and_keeps_actual_blue_star_design_after_sale_reload():
 var save=load("res://src/Application/save_data.gd").new();save.save_path=PATH;save.horse_collection.seed_trial();save.horse_collection.add_trial_parents()
 var horse:Dictionary=save.horse_collection.find("trial_a");horse.traits={"coat":5,"pattern":6,"spots":3,"mane":1,"finish":"normal"}
 var design:=HatAppearance.encode235(5,6,3);assert_false(save.select_hat(HatAppearance.encode235(8,6,3)))
 assert_true(save.save_progress());assert_true(save.hat_designs235.has(design));assert_true(save.select_hat(design));assert_true(save.sell_market_horse("trial_a"));assert_true(save.horse_collection.find("trial_a").is_empty())
 save.load_progress();assert_true(save._load_valid);assert_true(save.hat_designs235.has(design));assert_true(save.select_hat(design));assert_eq(save.hat_color,design)
 assert_eq(HatAppearance.decode(design),{"coat":5,"finish":6,"spots":3});assert_eq(HatAppearance.sanitize(design),design);save.free()
func test_original_only_plus_owned_designs_not_whole_palette():
 var collection:=HorseCollection.new();collection.seed_trial();var known:=HatDesigns235.collect({},collection)
 assert_eq(known.size(),1);assert_true(known.has(HatAppearance.encode235(10,0,0)))
 assert_eq(HatDesigns235.clean({"hat:v2:99:1:1":true,"bad":true}),{})
 collection.add_trial_parents();var next:=HatDesigns235.collect(known,collection);assert_eq(next.size(),3)
 collection.horses.resize(1);assert_eq(HatDesigns235.collect(next,collection),next)
