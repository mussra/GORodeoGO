extends GutTest
func test_five_icons_fit_cards_with_name_below_and_no_duplicate_hint():
 GameState.brand_intro_played=true
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);await wait_physics_frames(2);menu._show_games213();await wait_physics_frames(2)
 for entry in menu.GAMES213:
  var button=menu._games213.canvas.get_node("Navigate_"+str(entry.id))
  var icon:TextureRect=button.get_node("GameIcon223");var label:Label=button.get_node("GameName223")
  assert_not_null(icon.texture);assert_eq(icon.size,Vector2(104,104));assert_lt(icon.position.y+icon.size.y,label.position.y)
  assert_lte(label.position.y+label.size.y,button.size.y);assert_eq(label.text,entry.title)
 menu.free();await wait_physics_frames(2)
