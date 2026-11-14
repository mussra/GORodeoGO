extends GutTest
func test_identity_is_seeded_persisted_and_has_only_two_patterns_plus_plain():
 var a:=TownIdentity215.fresh(752026);assert_eq(a,TownIdentity215.fresh(752026));assert_ne(a,TownIdentity215.fresh(952026))
 var names:Array=[]
 for id in VillageCousins140.IDS:
  assert_true(a[id].pattern in [0,6,10]);assert_false(names.has(a[id].name));names.append(a[id].name)
  assert_true(Color.html_is_valid(a[id].base));assert_true(Color.html_is_valid(a[id].spot))
 assert_eq(TownIdentity215.clean(a,752026),a)
 var altered:=a.duplicate(true);altered.home.name="Pueblo persistido";altered.home.base="223344"
 assert_eq(TownIdentity215.clean(altered,752026).home,altered.home)
func test_legacy_additive_names_do_not_move_towns_or_unlock_visited():
 var state:=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]));state.known.home=true
 var old:=state.duplicate(true);old.erase("towns215");old.erase("hint215");old.erase("revealed215")
 var restored:=VillageCousins140.clean(old,752026)
 assert_eq(restored.doors,old.doors);assert_eq(restored.known,old.known);assert_eq(restored.arrivals,old.arrivals)
 assert_eq(restored.towns215,state.towns215);assert_eq(restored.hint215,"")
 var next:=TownIdentity215.hint(restored,"home");var target:String=next.hint215
 assert_ne(target,"home");assert_false(next.known.get(target,false));assert_true(next.revealed215[target])
 var places:=WorldPlaces144.fresh(752026,3);var sites:=WorldPlaces144.sites(752026,3,next)
 assert_eq(WorldPlaces144.available(places,sites).size(),0)
 assert_eq(next.doors,restored.doors);assert_eq(next.known,restored.known)
 assert_eq(VillageCousins140.clean(next,752026),next)
func test_shared_wall_materials_are_cached_and_miniature_patterns_are_distinct():
 var looks:=TownIdentity215.fresh(752026)
 for id in VillageCousins140.IDS:
  var tex:=TownPaint215.texture(looks[id]);assert_same(tex,TownPaint215.texture(looks[id]));assert_eq(tex.get_size(),Vector2(128,128))
  var image:=tex.get_image();assert_almost_eq(image.get_pixel(0,0).a,1.,.001)
 assert_ne(TownPaint215.texture(looks.home),TownPaint215.texture(looks.east138))
func test_hint_keeps_real_visit_and_direction_rules_separate():
 var state:=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]));state.known.home=true
 var next:=TownIdentity215.hint(state,"home");var id:String=next.hint215
 assert_true(VillageCousins140.cousin_hint(next,"home").contains(TownIdentity215.title(next,id)))
 assert_true(VillageCousins140.cousin_hint(next,"home").contains(VillageCousins140.direction(VillageCousins140.point(state,"home"),VillageCousins140.point(state,id))))
 assert_false(state.revealed215.has(id));assert_true(next.revealed215.has(id))
 assert_true(VillageCousins140.hear(next,id));assert_eq(next.hint215,"")
