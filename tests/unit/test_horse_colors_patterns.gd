extends GutTest
func test_optional_traits_validate_and_old_saves_restore()->void:
 var c:=HorseCollection.new();c.seed_trial();assert_true(c.restore(c.export_state()))
 assert_eq(HorseCollection.legs_index(c.horses[0].traits),-1)
 for key in ["legs","spots"]:
  var t:Dictionary={"coat":10,"pattern":0,"mane":0};t[key]=19;assert_true(c.valid_traits(t));t[key]=20;assert_false(c.valid_traits(t));t[key]=-2;assert_false(c.valid_traits(t));t[key]="2";assert_false(c.valid_traits(t))
func test_breeding_inherits_new_channels_and_roundtrips()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents()
 c.find("trial_a").traits.merge({"legs":0,"spots":3},true);c.find("trial_b").traits.merge({"legs":3,"spots":8,"pattern":11},true)
 var child:=c.breed("trial_a","trial_b",{"legs":1,"spots":0,"pattern":1})
 assert_eq(child.traits.legs,3);assert_eq(child.traits.spots,3);assert_eq(child.traits.pattern,11)
 var restored:=HorseCollection.new();assert_true(restored.restore(c.export_state()));assert_eq(restored.find(child.id).traits,child.traits)
func test_new_patterns_append_without_reassigning_existing_ids()->void:
 assert_eq(HorseCollection.PATTERNS[9],"Cebra");assert_eq(HorseCollection.PATTERNS[10],"Jirafa");assert_eq(HorseCollection.PATTERNS[11],"Vaca")
 var c:=HorseCollection.new()
 for pattern in [10,11]:
  var t:Dictionary={"coat":1,"mane":0,"pattern":pattern,"legs":0,"spots":3}
  assert_true(c.valid_traits(t));assert_between(HorseMarket.tier({"traits":t}),0,4);assert_false(c.suggest_name(t).is_empty())
func test_shared_maps_have_islands_and_gaps_and_wrap()->void:
 for pattern in [9,10,11]:
  var low:=0;var high:=0
  for y in range(0,96,3):
   for x in range(0,96,3):
    var value:=HorsePatternMap.coverage(Vector2(x,y),pattern)
    if value<.1:low+=1
    if value>.9:high+=1
  assert_gt(low,10);assert_gt(high,10)
  assert_almost_eq(HorsePatternMap.coverage(Vector2(5,8),pattern),HorsePatternMap.coverage(Vector2(101,104),pattern),.001)
func test_custom_legs_do_not_touch_tail_hooves_or_rider()->void:
 var source:Texture2D=load("res://art/player/walk_diag_down/frame_00.png")
 var base:=HorseAppearance.texture(source,"walk_diag_down",0,{"coat":10,"pattern":0,"mane":0}).get_image()
 var colored:=HorseAppearance.texture(source,"walk_diag_down",0,{"coat":10,"pattern":0,"mane":0,"legs":3}).get_image()
 var mask:Image=load("res://art/lower_legs_masks/walk_diag_down/frame_00.png").get_image()
 if mask.is_compressed():mask.decompress()
 var changed:=0
 for y in base.get_height():
  for x in base.get_width():
   if mask.get_pixel(x,y).r<.01:assert_eq(base.get_pixel(x,y),colored.get_pixel(x,y))
   elif base.get_pixel(x,y)!=colored.get_pixel(x,y):changed+=1
 assert_gt(changed,0)
func test_leg_save_persistence_and_rollback()->void:
 var script=load("res://src/Application/save_data.gd")
 var save=script.new();save.save_path="user://legs-persist-qa.dat";save.debug_mode=false;save.horse_collection.seed_trial()
 assert_true(save.set_horse_legs("original",0,true));assert_eq(save.horse_collection.find("original").traits.legs,0);assert_eq(save.horse_collection.find("original").traits.coat,10)
 assert_true(save.set_horse_pattern_color("original","pattern",11));assert_true(save.set_horse_pattern_color("original","spots",3))
 save.load_progress();assert_eq(save.horse_collection.find("original").traits.legs,0);assert_eq(save.horse_collection.find("original").traits.spots,3);assert_eq(save.horse_collection.find("original").traits.pattern,11)
 var before:Dictionary=save.horse_collection.export_state();save.save_path="user://missing-directory/legs.dat"
 assert_false(save.set_horse_legs("original",3));assert_eq(save.horse_collection.export_state(),before)
 assert_false(save.set_horse_pattern_color("original","coat",3));assert_eq(save.horse_collection.export_state(),before)
 assert_push_error_count(2)
 save.free();DirAccess.remove_absolute("user://legs-persist-qa.dat")
