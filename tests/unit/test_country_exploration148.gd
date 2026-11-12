extends GutTest
func test_exploration_is_local_and_available_destinations_require_visit():
 var data:=CountryRoute146.plan(456);var cells:Dictionary={};CountryExploration148.reveal(cells,data.entry);assert_lte(cells.size(),9)
 var source_cell:=Vector2i(floori(data.source.x/512.),floori(data.source.y/512.));assert_false(cells.has(source_cell))
 var ledger:=CountryLedger146.enter(CountryLedger146.fresh(123,3),Vector2.ZERO,456);assert_eq(CountryExploration148.available(ledger,data).map(func(s):return s.id),["entry"]);assert_eq(CountryExploration148.destination(ledger,data,"source"),{})
 ledger=CountryLedger146.record_position(ledger,data.sites.source);assert_eq(CountryExploration148.available(ledger,data).map(func(s):return s.id),["entry","source"]);assert_eq(CountryExploration148.destination(ledger,data,"source").pos,data.sites.source)
