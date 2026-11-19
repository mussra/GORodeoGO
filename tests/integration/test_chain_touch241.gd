extends GutTest
var old_story319:bool
var menu:Control
var snapshot:Dictionary
func before_each()->void:
 old_story319=SaveData.story_intro319;SaveData.story_intro319=true
 _ignore(get_tree().root.get_node("GutRunner"))
 snapshot={"debug":SaveData.debug_mode,"intro":SaveData.rodeo_intro240,"level":SaveData.highest_level_completed,"places":SaveData.world_places144.duplicate(true),"quests":SaveData.world_quests.duplicate(true),"wins":SaveData.victories240.duplicate(true)}
 SaveData.debug_mode=false;SaveData.rodeo_intro240=false;SaveData.highest_level_completed=0;SaveData.world_places144={};SaveData.world_quests={};SaveData.victories240=ModeVictories240.fresh();GameState.brand_intro_played=true
 menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);menu._show_games213()
 await wait_seconds(.3)
func after_each()->void:
 SaveData.story_intro319=old_story319
 if is_instance_valid(menu):menu.free()
 SaveData.debug_mode=snapshot.debug;SaveData.rodeo_intro240=snapshot.intro;SaveData.highest_level_completed=snapshot.level;SaveData.world_places144=snapshot.places;SaveData.world_quests=snapshot.quests;SaveData.victories240=snapshot.wins
func tap(at:Vector2)->void:
 var event:=InputEventScreenTouch.new();event.index=0;event.position=at;event.pressed=true;Input.parse_input_event(event)
 await wait_process_frames(2)
 event=InputEventScreenTouch.new();event.index=0;event.position=at;event.pressed=false;Input.parse_input_event(event)
 await wait_process_frames(2)
func test_locked_race_touch_does_not_start_game_and_keeps_requirements()->void:
 var card:Button=menu._games213.canvas.get_node("Navigate_race")
 assert_true(card.size.y>=150)
 await tap(card.get_global_rect().get_center())
 await wait_seconds(.2)
 assert_true(is_instance_valid(menu._games213));assert_false(menu._transitioning)
 assert_false(SaveData.mode_open240("race"))
func test_touch_opens_and_closes_crowns_without_launching_mode()->void:
 var card:Button=menu._games213.canvas.get_node("Navigate_crowns240")
 await tap(card.get_global_rect().get_center())
 var crowns:ModeCrowns240=null
 for child in menu.get_children():
  if child is ModeCrowns240:crowns=child
 assert_not_null(crowns)
 if crowns==null:return
 var back:Button=crowns.canvas.get_node("NavigationBack")
 assert_true(back.size.y>=56)
 await tap(back.get_global_rect().get_center())
 assert_false(is_instance_valid(crowns));assert_false(menu._transitioning)

func _ignore(node:Node)->void:
 if node is Control:node.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for child in node.get_children():_ignore(child)
func test_supplied_crown_icons_fit_their_cards_and_pending_uses_separate_assets()->void:
 var crowns:=ModeCrowns240.new();menu.add_child(crowns)
 await wait_process_frames(2)
 for mode in ModeVictories240.MODES:
  var icon:TextureRect=crowns.canvas.get_node("Crown_"+mode)
  assert_eq(icon.size,Vector2(126,114));assert_eq(icon.mouse_filter,Control.MOUSE_FILTER_IGNORE)
  assert_eq(icon.texture.get_size(),Vector2(512,512))
  assert_string_contains(icon.texture.resource_path,mode+"_pending.png")
  var image:=icon.texture.get_image();assert_eq(image.get_pixel(0,0).a,0.0)
 crowns.free()

func test_closed_crowns_are_the_only_style_and_have_no_toggle()->void:
 var before:Dictionary=SaveData.victories240.duplicate(true)
 var crowns:=ModeCrowns240.new();menu.add_child(crowns)
 await wait_process_frames(3)
 assert_false(crowns.has_method("_toggle_style241"))
 for child in crowns.canvas.get_children():
  if child is Button:assert_false(child.text.contains("Diseño:"))
 for mode in ModeVictories240.MODES:
  var icon:TextureRect=crowns.canvas.get_node("Crown_"+mode)
  assert_string_contains(icon.texture.resource_path,"/round/")
  assert_false(ResourceLoader.exists("res://art/ui/crowns241/"+mode+".png"))
 assert_eq(SaveData.victories240,before)
 crowns.free()
