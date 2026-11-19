extends GutTest
var old_path:String
func before_each():old_path=SaveData.save_path;SaveData.save_path="user://book256test.cfg"
func after_each():
 if FileAccess.file_exists(BreedingAdvice256.path()):DirAccess.remove_absolute(BreedingAdvice256.path())
 SaveData.save_path=old_path
func test_every_topic_has_three_short_tips_and_read_state_persists():
 assert_eq(BreedingAdvice256.IDS.size(),6)
 for i in 6:
  assert_eq(BreedingAdvice256.TIPS[i].size(),3);assert_true(BreedingAdvice256.mark(BreedingAdvice256.IDS[i]));assert_true(BreedingAdvice256.state().has(BreedingAdvice256.IDS[i]))
 assert_false(BreedingAdvice256.mark("not_a_tip"))
func test_master_parent_transmits_same_family_badge_not_progress_or_exclusive():
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();c.find("trial_a").master251=true
 for pattern_source in [0,1]:
  var child:=c.breed("trial_a","trial_b",{"pattern":pattern_source})
  assert_eq(child.get("master251",false),pattern_source==0)
  assert_false(child.has("completed_levels"));assert_false(child.has("mode_wins251"));assert_false(child.has("mastered_from251"));assert_false(child.get("supreme251",false))
  assert_eq(HorseFinish168.style(child),"master251" if pattern_source==0 else "")
 assert_true(c.restore(c.export_state()));assert_eq(c.horses.size(),5)
func test_either_master_parent_can_transmit_only_matching_pattern():
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();c.find("trial_b").master251=true
 assert_true(c.breed("trial_a","trial_b",{"pattern":1}).master251)
 assert_false(c.breed("trial_a","trial_b",{"pattern":0}).get("master251",false))
func test_reading_and_tutorial_dont_mutate_horses_or_create_rewards():
 var before:Dictionary=SaveData.horse_collection.export_state()
 var book:=BreedingBook256.new();add_child(book);await wait_process_frames(2)
 book.start_tutorial();assert_eq(book.page,0);assert_true(book.tutorial)
 for i in 6:
  book.show_page(i);assert_true(BreedingAdvice256.state().has(BreedingAdvice256.IDS[i]))
 assert_eq(SaveData.horse_collection.export_state(),before)
 book.finish();await wait_process_frames(2);assert_false(is_instance_valid(book))
func test_camera_transition_is_one_third_longer_with_same_hold():
 assert_eq(TownArrival244.OUT_SECONDS,1.6);assert_eq(TownArrival244.BACK_SECONDS,1.6);assert_eq(TownArrival244.HOLD_SECONDS,1.)
func test_menu_has_book_entry_and_world_mentor_is_near_home():
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);await wait_process_frames(2)
 assert_true(is_instance_valid(menu._book256));menu._book256.pressed.emit();await wait_process_frames(2)
 assert_true(menu.get_children().any(func(c):return c is BreedingBook256));menu.free()
 assert_eq(BreedingAdvice256.mentor().id,"mentor256")
func test_workshop_uses_same_equipment_panel_and_exits_without_purchase():
 var original:Dictionary=SaveData.horse_collection.export_state();var points:int=SaveData.equipment_points
 var room:=SaddleryRoom256.new();add_child(room);await wait_process_frames(2)
 room.open_equipment();assert_true(room.equipment is EquipmentPanel);assert_true(room.equipment.visible)
 room.equipment.closed.emit();assert_false(room.equipment.visible)
 room.open_equipment();assert_true(room.equipment.visible)
 assert_eq(SaveData.horse_collection.export_state(),original);assert_eq(SaveData.equipment_points,points)
 room.finish();await wait_process_frames(2);assert_false(is_instance_valid(room))

func test_appearance_chapter_uses_three_real_riderless_horse_textures():
 var book:=BreedingBook256.new();book.page=4;add_child(book)
 var textures:Array=[]
 for i in 3:
  var horse:TextureRect=book.content.get_node("AppearanceHorse321_"+str(i))
  assert_not_null(horse.texture)
  assert_gt(horse.texture.get_width(),0)
  assert_eq(horse.stretch_mode,TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
  assert_lte(horse.position.y+horse.size.y,359.)
  textures.append(horse.texture.get_image().get_data().hex_encode().sha256_text())
 assert_ne(textures[0],textures[1]);assert_ne(textures[1],textures[2])
 for child in book.content.get_children():assert_false(child is BreedingBook256.BookGlyph256)
 book.free()
