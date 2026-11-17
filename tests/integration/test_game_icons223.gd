extends GutTest
func test_six_icons_and_hints_stay_visible_locked_and_unlocked():
 var prior:bool=SaveData.debug_mode
 GameState.brand_intro_played=true
 for debug in [false,true]:
  SaveData.debug_mode=debug
  var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);await wait_physics_frames(3);menu._show_games213();await wait_physics_frames(3)
  for id in ["bulls","race","duel","joust","memory","crowns240"]:
   var button=menu._games213.canvas.get_node("Navigate_"+id)
   var icon:TextureRect=button.get_node("GameIcon223");var label:Label=button.get_node("GameName223");var hint:Label=button.get_node("GameHint250")
   assert_not_null(icon.texture);assert_eq(icon.size,Vector2(82,82));assert_lt(icon.position.x+icon.size.x,label.position.x)
   assert_lte(label.position.y+label.size.y,hint.position.y);assert_lte(hint.position.y+hint.size.y,button.size.y)
   assert_false(button.disabled);assert_eq(icon.mouse_filter,Control.MOUSE_FILTER_IGNORE)
   if id!="crowns240" and not SaveData.mode_open240(id):assert_eq(hint.text,ModeAccess240.card_requirement(id));assert_has(menu._games213.keep_open250,id)
  menu.free();await wait_physics_frames(3)
 SaveData.debug_mode=prior
func test_locked_choice_keeps_sheet_and_shows_specific_requirement():
 var prior:bool=SaveData.debug_mode;var intro:bool=SaveData.rodeo_intro240
 SaveData.debug_mode=false;SaveData.rodeo_intro240=false;GameState.brand_intro_played=true
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);await wait_physics_frames(3);menu._show_games213();await wait_physics_frames(3)
 var sheet=menu._games213
 menu._choose_game213("bulls")
 assert_same(menu._games213,sheet);assert_eq(sheet.canvas.get_node("GameAccess239").text,"Para jugar: "+ModeAccess240.requirement("bulls"));assert_false(SaveData.mode_open240("bulls"))
 menu.free();SaveData.debug_mode=prior;SaveData.rodeo_intro240=intro
