extends GutTest
func test_eight_directions_use_five_views_and_left_mirrors()->void:
 var directions=[Vector2.RIGHT,Vector2(1,1),Vector2.DOWN,Vector2(-1,1),Vector2.LEFT,Vector2(-1,-1),Vector2.UP,Vector2(1,-1)]
 var views=["side","diag_down","down","diag_down","side","diag_up","up","diag_up"]
 var flips=[false,false,false,true,true,true,false,false]
 for i in 8:
  assert_eq(AnimalDirection.view(directions[i]),views[i]);assert_eq(AnimalDirection.mirrored(directions[i]),flips[i])
func test_missing_diagonal_falls_back_without_claiming_new_view()->void:
 assert_eq(AnimalDirection.available_view(Vector2(1,1),["side","up","down"]),"side")
 assert_eq(AnimalDirection.available_view(Vector2(1,3),["side","up","down"]),"down")
 assert_eq(AnimalDirection.available_view(Vector2(1,-1),["side","up","down","diag_up"]),"diag_up")
