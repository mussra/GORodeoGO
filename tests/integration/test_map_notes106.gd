extends GutTest
func test_native_long_press_save_note_horse_reappears_and_delete():
 SaveData.save_path="user://notes106-real.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_notes106={};SaveData.world_tamed=[];SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false);world.set_process(false);world.set_physics_process(false)
 var horse=world._herd_horses.values()[0];var member_id:String=horse.herd.member_id;var traits:Dictionary=horse.herd.traits.duplicate(true);var pos:Vector2=horse.position
 world._toggle_map();var map=world._map_overlay;map._layout();map._ensure_terrain()
 var point:Vector2=map._to_map(pos,map._map_geometry.data.mins,map._map_geometry.cell,map._map_geometry.origin)
 var press=InputEventScreenTouch.new();press.index=4;press.position=point;press.pressed=true;map._gui_input(press);map._press_time106-=.7;map._process(.01)
 assert_not_null(world._note_dialog106,"native touch long press opens note")
 var release=InputEventScreenTouch.new();release.index=4;release.position=point;release.pressed=false;map._gui_input(release)
 assert_true(map.expanded,"long press does not close map")
 world._note_dialog106.saved.emit("Caballo para volver",false);await get_tree().process_frame
 var note:Dictionary=WorldNotes106.nearest(SaveData.world_notes106,pos,1000.);assert_false(note.is_empty());assert_eq(note.horse,member_id);assert_eq(note.text,"Caballo para volver")
 SaveData.trial_session_active=false;assert_true(SaveData.save_progress());world.free();SaveData.load_progress()
 assert_eq(WorldNotes106.nearest(SaveData.world_notes106,pos,1000.).horse,member_id)
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 var found:bool=false
 for animal in world._herd_horses.values():
  if animal.herd.member_id==member_id:found=true;assert_eq(animal.herd.traits,traits)
 assert_true(found,"same uncaptured seeded member reappears in its zone")
 world._toggle_map();world._map_overlay._layout();world._map_overlay._ensure_terrain();world._open_map_note106(pos);assert_not_null(world._note_dialog106)
 world._note_dialog106.deleted.emit();assert_true(SaveData.world_notes106.is_empty());world.free();DirAccess.remove_absolute(SaveData.save_path)
