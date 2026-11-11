extends GutTest
func test_distinct_levels_exact_threshold_and_no_skill_or_calm_shortcut():
 var c=HorseCollection.new();c.seed_trial();var h=c.find("original");h.traits.finish="galaxy";h["mastery"]={"jump":100,"dodge":100};h["stats"]={"calm":2.0}
 assert_eq(HorseMastery.percent(h),0.0);assert_false(HorseMastery.galaxy_master(h))
 for n in range(1,17):assert_true(HorseMastery.record(c,h.id,n))
 assert_eq(HorseMastery.percent(h),80.0);assert_false(HorseMastery.galaxy_master(h));assert_true(HorseMastery.galaxy_master(h,80))
 assert_false(HorseMastery.record(c,h.id,16));assert_eq(HorseMastery.percent(h),80.0)
 for n in range(17,21):assert_true(HorseMastery.record(c,h.id,n))
 assert_true(HorseMastery.galaxy_master(h));assert_eq(HorseMastery.percent(h),100.0)
 h.stage="foal";assert_false(HorseMastery.galaxy_master(h));h.stage="adult";h.traits.finish="normal";assert_false(HorseMastery.galaxy_master(h))
func test_legacy_empty_validation_and_restore():
 var c=HorseCollection.new();c.seed_trial();var h=c.find("original");assert_eq(HorseMastery.levels(h),[])
 h["completed_levels"]=[3,1,3,-1,21,"4"]
 assert_eq(HorseMastery.levels(h),[1,3]);assert_false(HorseMastery.record(c,"missing",2));assert_false(HorseMastery.record(c,h.id,0))
 var loaded=HorseCollection.new();assert_true(loaded.restore(c.export_state()));assert_eq(HorseMastery.levels(loaded.find(h.id)),[1,3])
func test_victory_credits_mounted_snapshot_and_rolls_back_with_save():
 var sut=load("res://src/Application/save_data.gd").new();sut.save_path="user://mastery83-qa.dat";sut.points_legacy_credit_applied=true;sut.horse_collection.seed_trial();sut.horse_collection.add_trial_parents()
 sut.horse_collection.selected="trial_b"
 assert_gt(sut.record_victory(1,{},"trial_a"),0);assert_eq(HorseMastery.levels(sut.horse_collection.find("trial_a")),[1]);assert_eq(HorseMastery.levels(sut.horse_collection.find("trial_b")),[])
 sut.load_progress();assert_eq(HorseMastery.levels(sut.horse_collection.find("trial_a")),[1])
 var before=sut.horse_collection.export_state();sut.save_path="user://missing_mastery83/fail.dat";assert_eq(sut.record_victory(2,{},"trial_a"),0);assert_eq(sut.horse_collection.export_state(),before);assert_push_error_count(1)
 sut.trial_session_active=true;assert_eq(sut.record_victory(2,{},"trial_a"),0);assert_eq(sut.horse_collection.export_state(),before);sut.free();DirAccess.remove_absolute("user://mastery83-qa.dat")
func test_level20_one_galaxy_offer_other_five_unchanged():
 var offers=HorseMarket.offers(20);assert_eq(offers.size(),6);assert_eq(offers.filter(func(h):return h.traits.finish=="galaxy").size(),1)
 assert_eq(offers[5].offer_id,"offer_20_5");assert_eq(offers,HorseMarket.offers(20));assert_true(HorseMarket.available(HorseCollection.new(),offers[5],20));assert_false(HorseMarket.available(HorseCollection.new(),offers[5],19))
func test_portrait_glow_is_master_only_and_intensity_is_configurable():
 var c=HorseCollection.new();c.seed_trial();var h=c.find("original");h.traits.finish="galaxy"
 var view=TextureRect.new();HorsePortrait.apply_horse(view,h)
 assert_eq(view.material.get_shader_parameter("galaxy_intensity"),.65)
 assert_ne(view.material.get_shader_parameter("mastery_aura"),true)
 assert_true(view.material.get_shader_parameter("galaxy_palette_preview"))
 for n in range(1,21):HorseMastery.record(c,h.id,n)
 HorsePortrait.apply_horse(view,h)
 assert_true(view.material.get_shader_parameter("mastery_aura"))
 assert_eq(view.material.get_shader_parameter("galaxy_intensity"),1.)
 h.traits.finish="normal";HorsePortrait.apply_horse(view,h)
 assert_ne(view.material.get_shader_parameter("mastery_aura"),true)
 assert_false(view.material.get_shader_parameter("galaxy_palette_preview"));view.free()
