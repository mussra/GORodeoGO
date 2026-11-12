extends GutTest
func test_region_notes_roundtrip_edit_delete_no_cap_and_failed_save():
 var save=load("res://src/Application/save_data.gd").new();add_child_autofree(save);save.save_path="user://notes106.dat";save.trial_session_active=false;save.world_notes106={};save.world_seed=42
 var note={"id":"n1","pos":Vector2(1900,470),"text":"Caballo rojo crin arcoíris","icon":"horse","horse":"herd_1,0#2","photo":""}
 assert_true(save.store_note106(note));save.load_progress();assert_eq(WorldNotes106.nearest(save.world_notes106,note.pos,30.).text,note.text)
 note.text="Volver aquí";assert_true(save.store_note106(note));assert_eq(save.world_notes106.values()[0].size(),1)
 save.save_path="user://notes106-missing/fail.dat";assert_false(save.delete_note106("n1"));assert_eq(save.world_notes106.values()[0].size(),1);assert_push_error_count(1)
 save.save_path="user://notes106.dat";assert_true(save.delete_note106("n1"));assert_true(save.world_notes106.is_empty());save.load_progress();assert_true(save.world_notes106.is_empty());DirAccess.remove_absolute(save.save_path)
func test_clean_rejects_corrupt_notes_and_keeps_unicode():
 var raw={"0,0":[{"id":"1","pos":Vector2.ZERO,"text":"Arcoíris","photo":""},{"id":"2","pos":"bad","text":"x"}]}
 var notes=WorldNotes106.clean(raw);assert_eq(notes["0,0"].size(),1);assert_eq(notes["0,0"][0].text,"Arcoíris")
func test_zoom_slider_clamp_and_retained_drag_no_rebuild_per_event():
 var old=SaveData.world_discovered.duplicate();SaveData.world_seed=42;SaveData.world_generator_version=3;SaveData.world_discovered.assign(["0,0","100,0"])
 var map=load("res://src/Presentation/frontier_world.gd").DiscoveryMap.new();map.world=Node2D.new();map.expanded=true;map.size=Vector2(700,410);map._ensure_terrain();map.zoom=8.;map._ensure_terrain()
 var before:int=map.terrain_rebuilds
 map._begin_drag106(Vector2(300,200))
 for i in 50:map._drag106(Vector2(300+i,200))
 assert_eq(map.terrain_rebuilds,before);assert_true(map.pan.is_finite());map._end_drag106(Vector2(349,200))
 map._begin_drag106(Vector2.ZERO);map._drag106(Vector2(100000,100000));assert_lt(map.pan.x,100000.);assert_eq(map.pan.y,0.);map._end_drag106(Vector2(100000,100000))
 map.world.free();map.free();SaveData.world_discovered=old
