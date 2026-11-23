extends GutTest
func test_five_minutes_no_stacking_and_expiry():
 var s:=Garden212.fresh();s.stage="empty";s.crops=3;s.discovered=true
 s=Garden212.action(s,"feed","original");assert_eq(s.crops,2);assert_eq(s.food.left,300.)
 assert_eq(Garden212.clean(s),s,"Remaining time is not clamped to legacy 120 seconds")
 s=Garden212.tick(s,0.,120.);assert_eq(s.food.left,180.);assert_eq(Garden212.multiplier(s,"original"),.85)
 assert_eq(Garden212.action(s,"feed","original"),{},"No stacking")
 s=Garden212.tick(s,0.,179.);assert_eq(s.food.left,1.);assert_eq(Garden212.multiplier(s,"original"),.85)
 s=Garden212.tick(s,0.,1.);assert_eq(s.food.left,0.);assert_eq(Garden212.multiplier(s,"original"),1.)
 s=Garden212.action(s,"feed","original");assert_eq(s.crops,1);assert_eq(s.food.left,300.)
func test_partial_legacy_effect_is_preserved_and_large_input_is_clamped():
 var s:=Garden212.fresh();s.food={"horse":"original","left":65.}
 assert_eq(Garden212.clean(s).food.left,65.,"No retroactive extension")
 s.food.left=450.;assert_eq(Garden212.clean(s).food.left,300.)
func test_new_remaining_time_roundtrips_through_independent_loader():
 var writer=SaveData.get_script().new();writer.save_path="user://food336-"+str(Time.get_ticks_usec())+".cfg";writer.load_progress()
 writer.world_garden212=Garden212.fresh();writer.world_garden212.stage="empty";writer.world_garden212.crops=3;writer.world_garden212.discovered=true
 var horse=writer.horse_collection.selected
 assert_true(writer.garden_action212("feed",horse));assert_eq(writer.world_garden212.food.left,300.)
 var reader=SaveData.get_script().new();reader.save_path=writer.save_path;reader.load_progress()
 assert_true(reader._load_valid);assert_eq(reader.world_garden212.food.left,300.);assert_eq(reader.world_garden212.crops,2)
 reader.free();writer.free()

func test_carrot_cap_preserves_whole_pending_harvest():
 for count_ in [8,9,10,25]:
  var s:=Garden212.fresh();s.stage="ripe";s.crops=count_;s.seeds=0;s.harvests=2
  var before:=s.duplicate(true)
  assert_eq(Garden212.action(s,"harvest"),{});assert_eq(s,before)
  assert_eq(Garden212.clean(s).crops,count_,"Legacy stock is not deleted")
 var s:=Garden212.fresh();s.stage="ripe";s.crops=8;s.seeds=0
 s=Garden212.action(s,"feed","original");s=Garden212.tick(s,0.,300.)
 s=Garden212.action(s,"harvest");assert_eq(s.crops,10);assert_eq(s.seeds,1);assert_eq(s.harvests,1);assert_eq(s.stage,"empty")
