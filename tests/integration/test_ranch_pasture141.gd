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
 panel.content.get_node("CollectionToRanch181").pressed.emit();await settle();assert_eq(panel.page,"pasture141")
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
