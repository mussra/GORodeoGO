extends GutTest
var previous_path319:String
var previous_story319:bool
var previous_trial319:bool
var previous_valid319:bool
var previous_guides323:Array
func before_each():
 previous_guides323=[GameState.controls_world323,GameState.rodeo_guide323];GameState.controls_world323=false;GameState.rodeo_guide323=false
 previous_path319=SaveData.save_path;previous_story319=SaveData.story_intro319
 previous_trial319=SaveData.trial_session_active;previous_valid319=SaveData._load_valid
 SaveData.trial_session_active=false;SaveData._load_valid=true
 SaveData.save_path="user://qa319-only.cfg"
func after_each():
 if FileAccess.file_exists(SaveData.save_path):DirAccess.remove_absolute(SaveData.save_path)
 SaveData.save_path=previous_path319;SaveData.story_intro319=previous_story319
 SaveData.trial_session_active=previous_trial319;SaveData._load_valid=previous_valid319
 GameState.controls_world323=previous_guides323[0];GameState.rodeo_guide323=previous_guides323[1]
func test_dialogue_progress_and_replacement_and_tap():
 var label:=DialogueLabel319.new();label.text="Un diálogo de prueba que aparece poco a poco.";add_child_autofree(label)
 assert_eq(label.visible_characters,0)
 label._process(.2);assert_gt(label.visible_characters,0);assert_lt(label.visible_characters,label.text.length())
 label.finish319();assert_eq(label.visible_characters,-1)
 label.text="Otro mensaje distinto";label._process(.01);assert_eq(label.previous319,label.text);assert_lt(label.visible_characters,label.text.length())
 var event:=InputEventMouseButton.new();event.pressed=true;event.button_index=MOUSE_BUTTON_LEFT;label._gui_input(event);assert_eq(label.visible_characters,-1)
func test_all_lengths_finish_in_less_than_ten_seconds():
 for length_ in [0,1,60,500,20000]:
  var label:=DialogueLabel319.new();label.text="a".repeat(length_);add_child_autofree(label)
  assert_lte(DialogueLabel319.seconds319(length_),9.5)
  label._process(9.6);assert_eq(label.visible_characters,-1)
func test_intro_duration_changes_and_no_collection_mutation():
 var original:Dictionary=SaveData.horse_collection.export_state().duplicate(true);var hat:String=SaveData.hat_color
 var intro:=StoryIntro319.new();intro.persist319=false;add_child_autofree(intro)
 assert_eq(intro.page319,0);assert_eq(intro.body319.visible_characters,0)
 intro.page319=1;intro._page319();var changes_:int=intro.preview_changes319;intro._process(1.);assert_gt(intro.preview_changes319,changes_)
 intro.page319=4;intro._page319();intro._process(1.);assert_ne(intro.hat319,"original")
 assert_eq(SaveData.hat_color,hat);assert_eq(SaveData.horse_collection.export_state(),original)
func test_intro_complete_and_replay_save_contract():
 SaveData.story_intro319=false
 var replay:=StoryIntro319.new();replay.persist319=false;add_child(replay);replay._finish319();await wait_process_frames(2)
 assert_false(SaveData.story_intro319)
 var intro:=StoryIntro319.new();add_child(intro);intro._finish319();await wait_process_frames(2)
 assert_true(SaveData.story_intro319)
 var config:=ConfigFile.new();assert_eq(config.load(SaveData.save_path),OK);assert_true(config.get_value("progress","story_intro319",false))
func test_count_catalogue_uses_visible_normalization():
 var entries:=HorseAtlas.filtered_entries({},[],false)
 assert_eq(entries.size(),47250)
 assert_eq(HorseAtlas.visible_groups261(entries).size(),41706)
func test_story_and_npc_bodies_share_component():
 var panel:=NpcDialog.new();panel.setup_story("Granjero","Una historia","Texto de historia");add_child_autofree(panel)
 assert_true(panel.get_node("StoryScroll/StoryBody") is DialogueLabel319)
 var npc:=NpcDialog.new();npc.setup(NpcQuests.NPCS[0],{});add_child_autofree(npc)
 assert_true(npc.get_node("QuestBody") is DialogueLabel319)

func test_first_menu_modal_and_settings_replay():
 SaveData.story_intro319=false;GameState.brand_intro_played=true
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu)
 await wait_process_frames(8)
 var intro:StoryIntro319=menu.get_node("StoryIntro319");intro.persist319=false
 assert_true(intro.is_visible_in_tree());assert_true(menu._play.disabled)
 assert_true(GameState.close_top_overlay(menu));await wait_process_frames(6)
 assert_null(menu.get_node_or_null("StoryIntro319"));assert_true(menu._play.disabled)
 assert_not_null(menu.get_node_or_null("BullTutorial323"));assert_true(GameState.close_top_overlay(menu));await wait_process_frames(4)
 assert_null(menu.get_node_or_null("BullTutorial323"));assert_true(GameState.close_top_overlay(menu));await wait_process_frames(4)
 assert_false(menu._play.disabled)
 menu._show_story319(false);await wait_process_frames(3)
 assert_not_null(menu.get_node_or_null("StoryIntro319"));menu.free()
func test_saved_intro_flag_and_new_file_default():
 SaveData.story_intro319=true;assert_true(SaveData.save_progress())
 var isolated:Node=load("res://src/Application/save_data.gd").new();isolated.save_path=SaveData.save_path;isolated.load_progress();assert_true(isolated.story_intro319)
 DirAccess.remove_absolute(SaveData.save_path);isolated.load_progress();assert_false(isolated.story_intro319);isolated.free()
func test_alma_uses_same_progressive_text():
 var book:=BreedingBook256.new();book.page=0;add_child_autofree(book)
 var tips:int=0
 for child in book.content.get_children():
  if child is DialogueLabel319:tips+=1
 assert_eq(tips,3)

func test_presentation_never_advances_on_time_only_continue():
 var intro:=StoryIntro319.new();intro.persist319=false;add_child_autofree(intro)
 for page_ in StoryIntro319.PAGES.size():
  assert_eq(intro.page319,page_)
  intro.body319._process(600.);intro._process(600.)
  assert_eq(intro.page319,page_,"Still on the same passage after ten minutes")
  assert_false(intro.is_queued_for_deletion())
  if page_<StoryIntro319.PAGES.size()-1:
   intro.next319.pressed.emit()
   assert_eq(intro.page319,page_+1)
 intro.next319.pressed.emit();assert_true(intro.is_queued_for_deletion())
func test_continue_advances_even_while_letters_are_appearing():
 var intro:=StoryIntro319.new();intro.persist319=false;add_child_autofree(intro)
 assert_eq(intro.body319.visible_characters,0)
 intro.next319.pressed.emit();assert_eq(intro.page319,1)
 intro.body319.finish319();assert_eq(intro.page319,1)

func test_pablo_identity_and_animated_entrance():
 assert_eq(RiderStory322.NAME,"Pablo")
 assert_string_contains(StoryIntro319.PAGES[0],"Pablo")
 var intro:=StoryIntro319.new();intro.persist319=false;add_child_autofree(intro)
 assert_eq(intro.canvas319.modulate.a,0.)
 assert_false(intro.body319.is_processing())
 assert_false(intro.entrance_done322)
 await wait_seconds(.8)
 assert_true(intro.entrance_done322);assert_true(intro.body319.is_processing())
 assert_almost_eq(intro.canvas319.modulate.a,1.,.01)
 assert_eq(intro.mounted319.position,Vector2(300,375))
 assert_eq(intro.page319,0)
func test_in_game_characters_address_pablo():
 var farmer:=NpcDialog.new();farmer.setup(NpcQuests.NPCS[0],{});add_child_autofree(farmer)
 assert_string_contains(farmer.get_node("QuestBody").text,"Pablo")
 var service:=TownServicePanel231.new();service.town_id="east140";add_child_autofree(service)
 var found:bool=false
 for child in service.get_children():
  if child is DialogueLabel319 and child.text.contains("Pablo"):found=true
 assert_true(found)
 assert_string_contains(BreedingAdvice256.TIPS[0][0],"Pablo")
 for role_ in ["farmer","florist","loco","saddler","gardener","alma"]:assert_string_contains(RiderStory322.greeting(role_),"Pablo")

func test_initial_controls_tutorial_is_manual_and_safe():
 var before_:Dictionary=SaveData.horse_collection.export_state().duplicate(true)
 var setting_:bool=GameState.anchored_movement258
 var intro:=StoryIntro319.new();intro.persist319=false;add_child_autofree(intro)
 intro.page319=6;intro._page319()
 assert_true(intro.tutorial323.visible);assert_false(intro.mounted319.visible)
 assert_string_contains(intro.body319.text,"izquierdo")
 var demo:=intro.tutorial323;demo.set_process(false)
 demo.press323(Vector2(340,220));assert_false(demo.touched323)
 demo.press323(Vector2(90,220));demo.drag323(Vector2(135,200));var at_:Vector2=demo.rider323.position;demo._process(.3)
 assert_ne(demo.rider323.position,at_);assert_true(demo.practiced323)
 demo.release323();var stopped_:Vector2=demo.rider323.position;demo._process(.3);assert_eq(demo.rider323.position,stopped_)
 intro.next319.pressed.emit();assert_eq(intro.page319,7);assert_eq(demo.mode323,1)
 assert_string_contains(intro.body319.text,"derecho")
 demo.press323(Vector2(80,230));assert_false(demo.touched323)
 demo.press323(Vector2(290,220));demo.drag323(Vector2(370,180));demo._process(.1)
 assert_gt(demo.distance323,0.);assert_gt(demo.aim323.x,0.);assert_lt(demo.aim323.y,0.)
 demo.release323();assert_true(demo.practiced323);assert_gt(demo.released323,0.)
 demo._process(2.);assert_eq(demo.distance323,0.)
 intro._process(600.);assert_eq(intro.page319,7);assert_false(intro.is_queued_for_deletion())
 assert_eq(SaveData.horse_collection.export_state(),before_);assert_eq(GameState.anchored_movement258,setting_)

func test_frontier_and_rodeo_guides_target_real_buttons():
 SaveData.story_intro319=true;GameState.brand_intro_played=true
 var old_intro:bool=SaveData.rodeo_intro240;SaveData.rodeo_intro240=true
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu)
 await wait_process_frames(5)
 menu._frontier_guide323();await wait_process_frames(2)
 var guide:TutorialGuide323
 for child in menu.get_children():
  if child is TutorialGuide323:guide=child
 assert_false(guide.go323.disabled);assert_same(guide.target323,menu._world_button);assert_string_contains(guide.words323,"explorar")
 guide.queue_free();await wait_process_frames(2)
 menu._show_games213();menu._rodeo_card323();await wait_process_frames(2)
 for child in menu.get_children():
  if child is TutorialGuide323:guide=child
 assert_false(guide.go323.disabled);assert_eq(guide.target323.name,"Navigate_bulls")
 guide.go323.pressed.emit();await wait_process_frames(4)
 for child in menu.get_children():
  if child is TutorialGuide323:guide=child
 assert_same(guide.target323,menu.level_grid.get_child(0));assert_true(menu._drawer.visible)
 menu.free();SaveData.rodeo_intro240=old_intro

func test_first_bull_familiarization_reuses_actual_level_one_without_saving():
 var saved_:Dictionary=SaveData.horse_collection.export_state().duplicate(true);var points_:int=SaveData.equipment_points;var levels_:int=SaveData.highest_level_completed
 var practice:=BullTutorial323.new();add_child(practice);await wait_process_frames(3)
 assert_eq(practice.level325.scene_file_path,"res://src/Presentation/level_0.tscn")
 assert_eq(practice.level325._level_number,1);assert_true(SaveData.familiarization325)
 assert_eq(practice.level325._upgrades.max_simultaneous_captures,1)
 practice.level325._trigger_win();assert_eq(SaveData.equipment_points,points_);assert_eq(SaveData.highest_level_completed,levels_)
 practice._finish323();await wait_process_frames(3)
 assert_false(SaveData.trial_session_active);assert_eq(SaveData.horse_collection.export_state(),saved_)

func test_practice_catalog_reuses_demos_without_progress_changes():
 assert_eq(PracticeCatalog323.entries323().size(),2)
 var demo=PracticeCatalog323.create323("controls");assert_true(demo is StoryIntro319);assert_eq(demo.page319,6);assert_false(demo.persist319);assert_true(demo.practice_only323);demo.free()
 var bull_demo=PracticeCatalog323.create323("bull");assert_true(bull_demo is BullTutorial323);bull_demo.free()
 assert_null(PracticeCatalog323.create323("not-implemented"))
