extends GutTest
func test_four_distinct_clues_journal_and_unknown_suggestions_in_any_order():
 for order in [["home","east138","west140","east140"],["east140","home","west140","east138"]]:
  var state:=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]))
  var clues:Array=[]
  for id in order:
   var target:=VillageCousins140.next_unknown(state,id)
   assert_false(state.known.get(target,false));assert_ne(target,id)
   assert_true(VillageCousins140.hear(state,id));assert_false(VillageCousins140.hear(state,id))
   assert_false(clues.has(VillageCousins140.clue(id)));clues.append(VillageCousins140.clue(id))
  assert_eq(state.known.size(),4);assert_eq(VillageCousins140.next_unknown(state,"home"),"")
  assert_true(VillageCousins140.journal(state).contains("4/4"))
  assert_eq(VillageCousins140.clean(state,752026),state)
func test_cardinal_direction_from_actual_positions_and_unknown_arrival():
 assert_eq(VillageCousins140.direction(Vector2.ZERO,Vector2(10,2)),"este")
 assert_eq(VillageCousins140.direction(Vector2.ZERO,Vector2(-10,2)),"oeste")
 assert_eq(VillageCousins140.direction(Vector2.ZERO,Vector2(2,-10)),"norte")
 assert_eq(VillageCousins140.direction(Vector2.ZERO,Vector2(2,10)),"sur")
 assert_eq(VillageCousins140.direction(Vector2.ONE,Vector2.ONE),"")
 var state:=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]))
 assert_false(VillageCousins140.cousin_hint(state,"home").contains("Vienes"))
 state.arrivals.home="sur";assert_true(VillageCousins140.cousin_hint(state,"home").begins_with("¿Vienes del sur?"))
func test_new_caserios_outside_old_exploration_and_true_unicorn_sight_only():
 var flora:=FloristJourney138.fresh(["18,0"])
 var state:=VillageCousins140.fresh(752026,["-15,0","18,0"],flora)
 assert_lt(state.doors.west140.x,-15.*1024.)
 assert_gt(state.doors.east140.x,19.*1024.)
 assert_eq(state.doors.east138,FloristJourney138.door(flora))
 assert_true(VillageCousins140.surprised({"species":"unicorn"}))
 assert_false(VillageCousins140.surprised({"traits":{"finish":"galaxy"}}))
 assert_true(VillageCousins140.clean(state,123).is_empty())
 assert_true(VillageCousins140.clue("home").contains("legendarios"))
