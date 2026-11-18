extends GutTest
func test_empty_hint_four_then_every_five_per_site():
 var search:=InteriorSearch264.new();search.define("shelf");search.define("floor")
 for n in range(1,20):
  var result:=search.tap("shelf");assert_eq(result.message,InteriorSearch264.EMPTY_HINT if n in [4,9,14,19] else "")
 assert_eq(search.tap("floor").message,"")
func test_found_item_has_no_empty_hint_and_post_find_cadence_restarts():
 var search:=InteriorSearch264.new();search.define("shelf","ribbon","owner")
 var result:=search.tap("shelf");assert_eq(result.kind,"found");assert_eq(result.message,"");assert_eq(result.ownership,"owner")
 for n in range(1,15):assert_eq(search.tap("shelf").message,InteriorSearch264.EXHAUSTED_HINT if n in [4,9,14] else "")
func test_discovery_is_once_and_never_gives_inventory_or_currency():
 var points:int=SaveData.equipment_points;var horses:=SaveData.horse_collection.export_state().duplicate(true)
 var search:=InteriorSearch264.new();search.define("basket","flower","free")
 assert_eq(search.tap("basket").kind,"found");assert_eq(search.tap("basket").kind,"empty")
 assert_eq(SaveData.equipment_points,points);assert_eq(SaveData.horse_collection.export_state(),horses)
func test_restore_only_accepts_matching_authored_item_and_resets_cadence():
 var a:=InteriorSearch264.new();a.define("a","ribbon");a.tap("a");a.tap("a")
 var b:=InteriorSearch264.new();b.define("a","ribbon");b.define("b","flower");b.restore_found(a.export_state())
 assert_eq(b.tap("a").kind,"empty");assert_eq(b.sites.a.empty_taps,1);assert_eq(b.tap("b").kind,"found")
 var c:=InteriorSearch264.new();c.define("a","other");c.restore_found(a.export_state());assert_eq(c.tap("a").kind,"found")
func test_unknown_site_is_silent_and_has_no_counter():
 var search:=InteriorSearch264.new();assert_eq(search.tap("absent").kind,"unknown");assert_true(search.sites.is_empty())
