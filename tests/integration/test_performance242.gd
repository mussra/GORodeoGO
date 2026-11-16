extends GutTest
var old_debug:bool
var old_path:String
func before_each():
 old_debug=SaveData.debug_mode;old_path=SaveData.save_path
 SaveData.save_path='user://performance242-test.cfg'
func after_each():
 SaveData.debug_mode=old_debug;SaveData.save_path=old_path;SaveData._load_valid=true;SaveData.trial_session_active=false
 DirAccess.remove_absolute('user://performance242-test.cfg')
func test_osd_gated_to_debug_and_never_consumes_touch():
 var osd=load('res://src/Presentation/performance_osd242.gd').new();add_child_autofree(osd)
 SaveData.debug_mode=false;osd._process(.6);assert_false(osd.label.visible)
 SaveData.debug_mode=true;osd._process(.6);assert_true(osd.label.visible)
 assert_eq(osd.label.mouse_filter,Control.MOUSE_FILTER_IGNORE)
 assert_true(osd.label.text.contains('GPU %: N/D'));assert_true(osd.label.text.contains('Guardados'))
 SaveData.debug_mode=false;osd._process(.6);assert_false(osd.label.visible)
func test_save_metrics_success_failure_and_trial_never_fake_writes():
 SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.horse_collection.seed_trial()
 var start:int=SaveData.save_metrics242.calls;assert_true(SaveData.save_progress());assert_eq(SaveData.save_metrics242.calls,start+1)
 assert_gt(SaveData.save_metrics242.last_bytes,0)
 var failures:int=SaveData.save_metrics242.failures;SaveData._load_valid=false;assert_false(SaveData.save_progress());assert_eq(SaveData.save_metrics242.failures,failures+1)
 SaveData._load_valid=true;SaveData.trial_session_active=true;start=SaveData.save_metrics242.calls
 assert_true(SaveData.save_progress());assert_eq(SaveData.save_metrics242.calls,start)
func test_map_raster_cache_is_separate_and_reuses_texture():
 SaveData.world_generator_version=1;SaveData.world_seed=752026;SaveData.world_discovered=['0,0'];SaveData.world_edits=[];SaveData.world_missions={};SaveData.world_tamed=[];SaveData.world_pigs=[]
 var map=WorldDiscoveryMap159.new();map.world=Node2D.new();map.size=Vector2(180,112);map._ensure_terrain()
 assert_not_null(map._terrain_viewport242);assert_eq(map._terrain.get_parent(),map._terrain_viewport242)
 assert_eq(map._terrain_image242.get_parent(),map._clip106)
 var texture=map._terrain_image242.texture;var rebuilds=map.terrain_rebuilds
 for i in 50:map._ensure_terrain()
 assert_eq(map.terrain_rebuilds,rebuilds);assert_eq(map._terrain_image242.texture,texture)
 map.expanded=true;map.size=Vector2(700,470);map._ensure_terrain();assert_gt(map.terrain_rebuilds,rebuilds)
 map.world.free();map.free()
func test_roster_cache_updates_on_focus_change_without_changing_quest_state():
 SaveData.world_generator_version=6;SaveData.world_seed=752026
 var world=load('res://src/Presentation/frontier_world.gd').new()
 var a:Array=world._npcs98();var quests:Dictionary=SaveData.world_quests.duplicate(true)
 assert_gt(a.size(),4);assert_eq(a,world._npcs98())
 TownNetwork234.ensure_near(752026,Vector2(120000,1000));var b:Array=world._npcs98()
 assert_ne(a,b);assert_eq(SaveData.world_quests,quests);world.free()
