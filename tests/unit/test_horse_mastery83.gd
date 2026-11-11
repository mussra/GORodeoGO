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
 assert_eq(view.material.get_shader_parameter("galaxy_intensity"),.72)
 assert_ne(view.material.get_shader_parameter("mastery_aura"),true)
 assert_ne(view.material.get_shader_parameter("mastery_sun"),true)
 assert_ne(view.material.get_shader_parameter("mastery_moon"),true)
 assert_true(view.material.get_shader_parameter("galaxy_palette_preview"))
 assert_almost_eq(view.material.get_shader_parameter("galaxy_star_density"),.04,.0001)
 for n in range(1,11):HorseMastery.record(c,h.id,n)
 HorsePortrait.apply_horse(view,h)
 assert_almost_eq(view.material.get_shader_parameter("galaxy_star_density"),.52,.0001)
 assert_ne(view.material.get_shader_parameter("mastery_aura"),true)
 assert_ne(view.material.get_shader_parameter("mastery_sun"),true)
 assert_ne(view.material.get_shader_parameter("mastery_moon"),true)
 for n in range(1,21):HorseMastery.record(c,h.id,n)
 HorsePortrait.apply_horse(view,h)
 assert_true(view.material.get_shader_parameter("mastery_aura"))
 assert_true(view.material.get_shader_parameter("mastery_sun"))
 assert_true(view.material.get_shader_parameter("mastery_moon"))
 assert_ne(view.material.get_shader_parameter("mastery_greek_preview"),true)
 assert_eq(view.material.get_shader_parameter("mastery_mark_scale"),.7)
 assert_eq(view.material.get_shader_parameter("galaxy_intensity"),1.)
 assert_eq(view.material.get_shader_parameter("galaxy_star_density"),1.)
 assert_eq(view.material.get_shader_parameter("mastery_aura_strength"),1.8)
 h.traits.finish="normal";HorsePortrait.apply_horse(view,h)
 assert_ne(view.material.get_shader_parameter("mastery_aura"),true)
 assert_ne(view.material.get_shader_parameter("mastery_sun"),true)
 assert_ne(view.material.get_shader_parameter("mastery_moon"),true)
 assert_false(view.material.get_shader_parameter("galaxy_palette_preview"));view.free()
func test_gameplay_look_uses_horse_progress_not_genes_and_does_not_mutate():
 var c=HorseCollection.new();c.seed_trial();var h=c.find("original");h.traits.finish="galaxy";h.traits.emblem=HorseEmblem.DEFAULT.duplicate(true)
 var before=h.duplicate(true);var zero=HorseGalaxyLook.state(h)
 assert_false(zero.master);assert_eq(zero.percent,0.);assert_eq(h,before)
 for n in range(1,21):HorseMastery.record(c,h.id,n)
 var look=HorseGalaxyLook.state(h);assert_true(look.master);assert_eq(look.percent,100.)
 var old=h.duplicate(true)
 var normal=PixelLabTrial.pose_texture("rider","side",0,h.traits)
 var master=PixelLabTrial.pose_texture("rider","side",0,h.traits,h)
 assert_ne(normal,master);assert_eq(h,old)
 var drink_normal=HorseDrink.texture(0,h.traits,"original")
 var drink_master=HorseDrink.texture(0,h.traits,"original",h)
 assert_ne(drink_normal,drink_master);assert_eq(h,old)
 h["completed_levels"]=[]
 assert_false(HorseGalaxyLook.state(h).master);assert_eq(h.traits.emblem,HorseEmblem.DEFAULT)
 assert_eq(HorseGalaxyLook.marks(Vector2(69,57),"up").x,0.)
func test_galaxy_mane_tail_coverage_all_nominal_views_without_mask_edits():
 var c=HorseCollection.new();c.seed_trial();var h=c.find("original");h.traits.finish="galaxy";h["completed_levels"]=[1,2,3,4,5,6,7,8,9,10]
 for view in ["side","down","up","diag_down","diag_up"]:
  for frame in 9:
   var raw:Image=load("res://art/experimental/pixellab/rider/%s/frame_%02d.png"%[view,frame]).get_image()
   var mask:Image=load("res://art/experimental/pixellab_masks_review_v5/rider/%s/color_%02d.png"%[view,frame]).get_image()
   var out:Image=PixelLabTrial.pose_texture("rider",view,frame,h.traits,h).get_image()
   var mane=0;var changed=0;var alpha_errors=0;var protected_errors=0
   for y in raw.get_height():
    for x in raw.get_width():
     var m=mask.get_pixel(x,y);var before=raw.get_pixel(x,y);var after=out.get_pixel(x,y)
     if m.g>.5 and before.a>.1:
      mane+=1
      if before!=after:changed+=1
     if absf(before.a-after.a)>.005:alpha_errors+=1
     if maxf(m.r,m.g)<.02 and before!=after:protected_errors+=1
   assert_eq(changed,mane,"entire mane/tail recoloured "+view+str(frame))
   assert_eq(alpha_errors,0,"normal never adds halo "+view+str(frame))
   assert_eq(protected_errors,0,"rider/tack stay original "+view+str(frame))
func test_master_all_views_protect_original_rider_and_keeps_marks_on_coat():
 var c=HorseCollection.new();c.seed_trial();var h=c.find("original");h.traits.finish="galaxy"
 for n in range(1,21):HorseMastery.record(c,h.id,n)
 for view in ["side","down","up","diag_down","diag_up"]:
  for frame in 9:
   var raw:Image=load("res://art/experimental/pixellab/rider/%s/frame_%02d.png"%[view,frame]).get_image()
   var mask:Image=load("res://art/experimental/pixellab_masks_review_v5/rider/%s/color_%02d.png"%[view,frame]).get_image()
   var uv:Image=load("res://art/experimental/pixellab_preview_uv/rider/%s/frame_%02d.png"%[view,frame]).get_image()
   var out:Image=PixelLabTrial.pose_texture("rider",view,frame,h.traits,h).get_image()
   var errors=0;var sun=0;var moon=0
   for y in raw.get_height():
    for x in raw.get_width():
     var before=raw.get_pixel(x,y);var m=mask.get_pixel(x,y)
     if maxf(m.r,m.g)<.02 and before.a>.02 and before!=out.get_pixel(x,y):errors+=1
     if m.r>.5:
      var ink=HorseGalaxyLook.marks(HorseAppearance.body_point(uv,x,y,0),view)
      if ink.x>.15:sun+=1
      if ink.y>.15:moon+=1
   assert_eq(errors,0,"master rider/tack unchanged "+view+str(frame))
   if view in ["side","down","diag_down"]:assert_gt(sun,0,"chest sun visible "+view+str(frame))
   else:assert_eq(sun,0,"no chest sun from rear")
   if view!="down":assert_gt(moon,0,"thigh moon visible "+view+str(frame))
   else:assert_eq(moon,0,"no thigh moon from front")
