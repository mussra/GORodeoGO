extends GutTest
var world:Node2D
func before_each():
 SaveData.save_path="user://towns215-test.cfg";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_flora138={};SaveData.world_places144={};SaveData.world_garden212=Garden212.fresh();SaveData.world_discovered=[];SaveData.world_quests={};SaveData.world_missions={};SaveData.world_tamed=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.player.set_physics_process(false)
func after_each():
 for store in [world._chunk_pending,world._chunk_built]:
  for key in store:world._discard_builder(store[key])
 world.free();DirAccess.remove_absolute(SaveData.save_path)
func test_real_npc_hint_atomic_save_pin_reload_and_no_first_time_siesta():
 world.player.position=VillageCousins140.point(SaveData.world_cousins140,"home");world._open_cousin140("home")
 var before:=SaveData.world_cousins140.duplicate(true);SaveData._load_valid=false;world._npc_dialog._hint215()
 assert_eq(SaveData.world_cousins140,before);assert_true(world._npc_dialog.body.text.contains("No se pudo guardar"))
 SaveData._load_valid=true;world._npc_dialog._hint215();var id:String=SaveData.world_cousins140.hint215
 assert_false(id.is_empty());assert_true(SaveData.world_cousins140.revealed215[id]);assert_false(SaveData.world_cousins140.known.has(id))
 assert_true(world._npc_dialog.body.text.contains(TownIdentity215.title(SaveData.world_cousins140,id)))
 assert_true(is_instance_valid(world._npc_dialog.get_node("TownPreview215")))
 assert_false(world._travel144.available().any(func(site):return site.id==id))
 var saved:=SaveData.world_cousins140.duplicate(true);SaveData.load_progress();assert_eq(SaveData.world_cousins140,saved)
 assert_eq(SaveData.world_position,world.player.position)
 world._close_npc();world._map_overlay.expanded=true;world._map_overlay._layout();world._map_overlay._ensure_terrain()
 world._map_overlay._select_site144(world._map_overlay._town_marker215(id)+world._map_overlay._map_geometry.area.position)
 var sheet:=world._hud.get_child(world._hud.get_child_count()-1) as NavigationSheet
 assert_not_null(sheet);assert_eq(sheet.entries.size(),1);assert_eq(sheet.entries[0].id,"focus215")
 assert_true(GameState.close_top_overlay(world));await wait_process_frames(2)
 var discovered:=SaveData.world_discovered.duplicate()
 world._map_overlay.center_note162({"id":"town215:"+id,"pos":VillageCousins140.point(SaveData.world_cousins140,id)})
 assert_eq(SaveData.world_discovered,discovered,"Centering a clue never reveals terrain")
 var site:Dictionary=WorldPlaces144.sites(752026,3,SaveData.world_cousins140).filter(func(s):return s.id==id)[0]
 world.player.position=site.pos;world._travel144.visit_clock=0;world._travel144.record_visits()
 assert_true(SaveData.world_places144.visited[id]);assert_eq(SaveData.world_cousins140.hint215,"")
 assert_true(world._travel144.available().any(func(s):return s.id==id))
