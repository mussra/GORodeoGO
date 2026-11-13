extends GutTest
var panel:HorsePanel
var before:Dictionary
func before_each():
 SaveData.trial_session_active=false;SaveData.debug_mode=false;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 SaveData.horse_collection.breed("trial_a","trial_b",{})
 before=SaveData.horse_collection.export_state();panel=HorsePanel.new();add_child(panel)
 await get_tree().process_frame;await get_tree().process_frame
func after_each():
 assert_eq(SaveData.horse_collection.export_state(),before,"Viewing must not change saved collection")
 panel.free();await get_tree().process_frame
func ranch()->RanchPasturePanel141:
 for child in panel.content.get_children():
  if child is RanchPasturePanel141:return child
 return null
func settle():
 await get_tree().process_frame;await get_tree().process_frame
func test_real_menu_open_detail_back_filter_and_list():
 panel.open_section("pasture141");await settle();assert_not_null(ranch());assert_eq(ranch().size,Vector2(1280,720))
 ranch().tier=0;ranch().refresh()
 var button:Button=ranch().content.find_child("PastureHorse_trial_a",true,false);assert_not_null(button)
 button.pressed.emit();await settle();assert_eq(panel.page,"detail");assert_eq(panel.focus_id,"trial_a");assert_eq(panel.detail_origin,"pasture141")
 panel.go_back();await settle();assert_eq(panel.page,"pasture141");assert_eq(ranch().tier,0)
 ranch().list_requested.emit();await settle();assert_eq(panel.page,"collection")
 panel.open_section("pasture141");await settle();ranch().closed.emit();await settle();assert_eq(panel.page,"hub")
func test_shared_animated_adults_static_foal_and_family():
 panel.open_section("pasture141");await settle();var p:=ranch();assert_eq(p.animated.size(),3)
 var a:AnimatedSprite2D=p.animated[0];assert_eq(a.animation,&"walk");assert_true(a.is_playing());assert_eq(a.sprite_frames.get_frame_count("walk"),9);assert_false(a.sprite_frames.has_animation("walk_up"))
 var frame:int=a.frame;await get_tree().create_timer(.16).timeout;assert_ne(a.frame,frame)
 p.family_id="child_1";p.refresh();assert_eq(p.animated.size(),2)
 var static_foals:int=0
 for n in p.content.get_children():
  if n is Sprite2D and not n is AnimatedSprite2D:static_foals+=1
 assert_eq(static_foals,1)
 p.content.find_child("NavigationBack",true,false).pressed.emit();assert_eq(p.family_id,"")
func test_sold_ancestor_remains_in_family_not_owned_paddock():
 assert_true(HorseMarket.sell(SaveData.horse_collection,"trial_b"));before=SaveData.horse_collection.export_state()
 panel.open_section("pasture141");await settle();assert_eq(ranch().animated.size(),2)
 ranch().family_id="child_1";ranch().refresh();assert_eq(ranch().animated.size(),2)
 assert_eq(RanchPastures141.family(SaveData.horse_collection,"child_1")[1].id,"trial_b")
 assert_true(RanchPastures141.family(SaveData.horse_collection,"child_1")[1].sold)
func test_preview_bounded_and_distinct_galaxy_mastery():
 var Art=preload("res://src/Presentation/wild_horse_art.gd");var h:Dictionary=SaveData.horse_collection.find("trial_a").duplicate(true);h.traits.finish="galaxy"
 var a=Art.new();a.configure_preview141(h);panel.add_child(a)
 # Cache must follow the same explicit presentation state as gameplay, no inferred purity.
 var akey:String=PixelLabTrial.cache_key(h.traits)+str(HorseGalaxyLook.state(h));assert_true(Art.preview_frames141.has(akey))
 assert_eq(a.sprite_frames.get_frame_count("walk"),9);assert_lte(Art.preview_frames141.size(),36)
 var mastered:Dictionary=h.duplicate(true);mastered["completed_levels"]=range(1,LevelCatalog.MAX_LEVEL+1)
 var b=Art.new();b.configure_preview141(mastered);panel.add_child(b)
 assert_ne(a.sprite_frames,b.sprite_frames);assert_true(HorseGalaxyLook.state(mastered).master)
 var c=Art.new();c.configure_preview141(h);panel.add_child(c);assert_eq(a.sprite_frames,c.sprite_frames)

func test_paddock_uses_exact_mounted_side_texture_hat_and_cosmetics():
 SaveData.hat_color="blue"
 panel.open_section("pasture141");await settle()
 var p:=ranch()
 for i in p.animated.size():
  var a:AnimatedSprite2D=p.animated[i];var h:Dictionary=SaveData.horse_collection.horses[i]
  for frame in 9:assert_eq(a.sprite_frames.get_frame_texture("walk",frame),PixelLabTrial.pose_texture("rider","side",frame,h.traits,h))
 SaveData.hat_color="original"

func test_collection_view_selector_preserves_data_filter_and_detail_origin():
 panel.open_section("collection");await settle()
 assert_not_null(panel.content.find_child("CollectionScroll118",true,false))
 panel.content.get_node("CollectionRanch182").pressed.emit();await settle()
 assert_eq(panel.page,"collection");assert_eq(panel.collection_mode182,"ranch");assert_true(ranch().embedded182)
 assert_false(panel.content.get_node("CollectionList182").disabled,"Nested view must not block the common selector")
 ranch().tier=0;ranch().refresh()
 ranch().content.find_child("PastureHorse_trial_a",true,false).pressed.emit();await settle()
 assert_eq(panel.page,"detail");assert_eq(panel.detail_origin,"collection")
 panel.go_back();await settle();assert_eq(panel.page,"collection");assert_eq(panel.collection_mode182,"ranch");assert_eq(ranch().tier,0)
 panel.content.get_node("CollectionList182").pressed.emit();await settle()
 assert_eq(panel.collection_mode182,"list");assert_null(ranch());assert_not_null(panel.content.find_child("CollectionScroll118",true,false))
 panel.content.get_node("CollectionRanch182").pressed.emit();await settle();assert_eq(ranch().tier,0)
 assert_null(panel.content.find_child("CollectionToRanch181",true,false))

func click182(button:Button):
 var pos:Vector2=button.get_global_rect().get_center()
 var motion:=InputEventMouseMotion.new();motion.position=pos;Input.parse_input_event(motion);await settle()
 for pressed in [true,false]:
  var e:=InputEventMouseButton.new();e.button_index=MOUSE_BUTTON_LEFT;e.pressed=pressed;e.position=pos;Input.parse_input_event(e);await settle()
func test_real_pointer_changes_modes_in_both_directions():
 panel.open_section("collection");await settle();await click182(panel.content.get_node("CollectionRanch182"))
 assert_eq(panel.collection_mode182,"ranch");assert_not_null(ranch())
 await click182(panel.content.get_node("CollectionList182"))
 assert_eq(panel.collection_mode182,"list");assert_null(ranch())

func test_one_collection_menu_entry_and_two_named_views():
 panel.open_section("hub");await settle()
 assert_not_null(panel.content.get_node("Navigate_collection"))
 var duplicates:int=0
 for child in panel.content.get_children():
  if child is Button and child.text=="Mi rancho":duplicates+=1
 assert_eq(duplicates,0)
 panel.content.get_node("Navigate_collection").pressed.emit();await settle()
 assert_eq(panel.content.get_node("CollectionList182").text,"Vista por propiedades")
 assert_eq(panel.content.get_node("CollectionRanch182").text,"Vista de colección")
 assert_null(panel.content.find_child("CollectionToRanch181",true,false))

func test_summary_and_skills_in_both_views_without_changing_horse():
 panel.open_section("collection");await settle()
 var h:Dictionary=SaveData.horse_collection.find("trial_a")
 var summary=panel.content.find_child("HorseSummary185_trial_a",true,false)
 assert_not_null(summary);assert_almost_eq(summary.get_node("AverageBar185").value,HorseSummary185.average(h),.001)
 panel.content.get_node("CollectionRanch182").pressed.emit();await settle()
 summary=ranch().content.find_child("HorseSummary185_trial_a",true,false)
 assert_not_null(summary);assert_almost_eq(summary.get_node("AverageBar185").value,HorseSummary185.average(h),.001)
 var badges:Array=[]
 for n in summary.get_parent().get_children():
  if n is JumpBadge:badges.append(n)
 assert_eq(badges.size(),8)
 assert_eq(badges[2].capable,HorseTraining.knows(h,"jump"))
 assert_eq(badges[3].capable,HorseTraining.knows(h,"dodge"))

func test_summary_popup_keeps_horse_hit_areas_transparent_and_restores_input():
 panel.open_section("collection");await settle()
 panel.content.get_node("CollectionRanch182").pressed.emit();await settle()
 var summary=ranch().content.find_child("HorseSummary185_original",true,false)
 var grid=summary.get_parent()
 var taps:Array=[]
 for c in grid.get_children():
  if c is Button and c.tooltip_text.begins_with("Ver ficha:"):taps.append(c)
 assert_eq(taps.size(),4)
 var art:AnimatedSprite2D=ranch().animated[0]
 var frames:SpriteFrames=art.sprite_frames
 summary.get_child(0).pressed.emit();await settle()
 var dialog:AcceptDialog=summary.get_children().filter(func(c):return c is AcceptDialog)[0]
 assert_true(dialog.visible)
 for tap in taps:
  assert_true(tap.disabled,"modal still blocks background input")
  assert_true(tap.get_theme_stylebox("disabled") is StyleBoxEmpty,"blocked invisible hit area cannot cover horse")
 assert_true(summary.get_child(0).get_theme_stylebox("disabled") is StyleBoxEmpty)
 assert_true(art.is_visible_in_tree());assert_eq(art.sprite_frames,frames);assert_true(art.is_playing())
 dialog.queue_free();await settle()
 for tap in taps:assert_false(tap.disabled,"closing popup restores horse input")
 assert_true(art.is_visible_in_tree())
