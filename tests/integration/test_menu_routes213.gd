extends GutTest
var old_story319:bool
var m:Control
var old_intro:bool
var old_debug302:bool
var old_size302:Vector2i
func before_each():
 old_story319=SaveData.story_intro319;SaveData.story_intro319=true
 old_debug302=SaveData.debug_mode;SaveData.debug_mode=true;old_size302=get_tree().root.size;get_tree().root.size=Vector2i(1280,720)
 old_intro=GameState.brand_intro_played;GameState.brand_intro_played=true
 var runner=get_tree().root.get_node("GutRunner");ignore(runner)
 m=load("res://src/Presentation/main_menu.tscn").instantiate();m.set_script(load("res://tests/integration/menu_routes213_fixture.gd"));add_child(m)
func after_each():
 SaveData.story_intro319=old_story319
 if is_instance_valid(m):m.free()
 GameState.brand_intro_played=old_intro;SaveData.debug_mode=old_debug302;get_tree().root.size=old_size302
func ignore(n:Node):
 if n is Control:n.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for c in n.get_children():ignore(c)
func tap(b:Button):
 var point:Vector2=get_viewport().get_final_transform()*b.get_global_rect().get_center()
 for down in [true,false]:
  var e:=InputEventScreenTouch.new();e.index=2;e.position=point;e.pressed=down;Input.parse_input_event(e);Input.flush_buffered_events();await wait_process_frames(3)
func test_six_game_cards_route_on_real_native_touches_and_back():
 await wait_seconds(.8)
 for extent in [Vector2(960,540),Vector2(1280,720),Vector2(1600,720)]:
  get_tree().root.size=Vector2i(extent);await wait_process_frames(3);m.size=extent;m._layout();await wait_process_frames(3)
  for id in ["bulls","race","duel","joust","memory"]:
   await tap(m._play);assert_true(is_instance_valid(m._games213));assert_eq(m._games213.entries.size(),6)
   var card:Button=m._games213.canvas.get_node("Navigate_"+id)
   assert_lte(card.get_global_rect().end.x,extent.x)
   await tap(card)
   if id=="bulls":
    assert_true(m._drawer.visible);m.navigate_back();await wait_process_frames(3);assert_true(is_instance_valid(m._games213))
    assert_true(GameState.close_top_overlay(m));await wait_process_frames(3)
   else:
    assert_eq(m.launched213,m.ROUTES213[id]);assert_true(ResourceLoader.exists(m.launched213))
  await tap(m._play)
  assert_true(is_instance_valid(m._games213),"Games reopened at "+str(extent))
  assert_true(GameState.close_top_overlay(m),"Back found game overlay at "+str(extent))
  await wait_process_frames(3)
  assert_false(is_instance_valid(m._games213),"Back closed game overlay at "+str(extent))
func test_equipment_and_settings_touch_routes_have_no_debug_on_root():
 await wait_seconds(.8)
 assert_false(m._missions.visible)
 for name_ in ["DuelEntry193","JoustEntry196","MemoryEntry207","RaceEntry190"]:assert_null(m._hero.get_node_or_null(name_))
 await tap(m._equipment_button);assert_true(m._equipment_panel.visible);assert_true(GameState.close_top_overlay(m));await wait_process_frames(3)
 assert_false(m._equipment_panel.visible)
 await tap(m._settings_button);assert_not_null(m.get_node_or_null("Settings213"))
 assert_true(GameState.close_top_overlay(m));await wait_process_frames(3);assert_null(m.get_node_or_null("Settings213"))
