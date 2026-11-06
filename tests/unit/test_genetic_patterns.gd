extends GutTest
func test_new_pattern_ids_append_and_breed()->void:
 assert_eq(HorseCollection.PATTERNS.slice(0,5),["Liso","Parches","Moteado","Trasera blanca","Patas claras"])
 assert_eq(HorseCollection.PATTERNS.size(),10)
 for pattern in range(5,10):
  var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents()
  c.find("trial_a").traits.pattern=pattern
  var t:Dictionary=c.preview("trial_a","trial_b",{"pattern":0})
  assert_eq(t.pattern,pattern)
  assert_true(c.valid_traits(t))
  var h:Dictionary=c.breed("trial_a","trial_b",{"pattern":0})
  assert_eq(h.traits.pattern,pattern)
  var restored:=HorseCollection.new();assert_true(restored.restore(c.export_state()))
  assert_eq(restored.find(h.id).traits.pattern,pattern)
func test_old_save_stays_compatible()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents()
 var restored:=HorseCollection.new();assert_true(restored.restore(c.export_state()))
 assert_eq(restored.find("trial_a").traits.pattern,1)
 assert_eq(restored.selected,"original")
func test_new_shapes_and_layout()->void:
 assert_eq(HorseAppearance.spots().size(),128)
 for a in HorseAppearance.spots():
  for b in HorseAppearance.spots():
   if a==b:continue
   assert_gte(Vector2(a.x,a.y).distance_to(Vector2(b.x,b.y)),6.4)
 for pattern in range(5,10):
  var count:int=0
  for y in range(40,80):
   for x in range(15,80):
    if HorseAppearance.genetic_mark(Vector2(x,y),pattern):count+=1
  assert_gt(count,10)
 assert_false(HorseAppearance.shape_point(Vector2(4,4),5))
 assert_true(HorseAppearance.shape_point(Vector2(0,0),5))
func test_special_eyes_inherit_restore_and_mask_only()->void:
 for eye in [20,21]:
  var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();c.find("trial_a").traits.eyes=eye
  var h:Dictionary=c.breed("trial_a","trial_b",{"eyes":0})
  assert_eq(h.traits.eyes,eye)
  var saved:=HorseCollection.new();assert_true(saved.restore(c.export_state()));assert_eq(saved.find(h.id).traits.eyes,eye)
  var t:Dictionary={"coat":19,"pattern":2,"mane":3,"eyes":10}
  var source:Texture2D=load("res://art/foal/base.png")
  var normal:Image=HorseAppearance.texture(source,"foal",0,t).get_image()
  t.eyes=eye;var changed:Image=HorseAppearance.texture(source,"foal",0,t).get_image()
  var mask:Image=load("res://art/foal/eyes.png").get_image();if mask.is_compressed():mask.decompress()
  var inside:int=0;var outside:int=0
  for y in normal.get_height():
   for x in normal.get_width():
    if normal.get_pixel(x,y)!=changed.get_pixel(x,y):
     if mask.get_pixel(x,y).r>.001:inside+=1
     else:outside+=1
  assert_gt(inside,0);assert_eq(outside,0)
func test_eye_bounds_and_galaxy_effect()->void:
 var c:=HorseCollection.new()
 assert_eq(HorseCollection.EYES.size(),22)
 assert_true(c.valid_traits({"coat":0,"pattern":9,"mane":5,"eyes":21}))
 assert_false(c.valid_traits({"coat":0,"pattern":9,"mane":5,"eyes":22}))
 var t:Dictionary={"coat":19,"pattern":0,"mane":3,"eyes":10}
 var source:Texture2D=load("res://art/player/walk_diag_down/frame_00.png")
 var normal:Image=HorseAppearance.texture(source,"walk_diag_down",0,t).get_image()
 t.finish="galaxy";var changed:Image=HorseAppearance.texture(source,"walk_diag_down",0,t).get_image()
 var mask:Image=load("res://art/horse_masks/walk_diag_down/frame_00.png").get_image();if mask.is_compressed():mask.decompress()
 var outside:int=0;var inside:int=0
 for y in normal.get_height():
  for x in normal.get_width():
   if normal.get_pixel(x,y)!=changed.get_pixel(x,y):
    if maxf(mask.get_pixel(x,y).r,mask.get_pixel(x,y).g)>.001:inside+=1
    else:outside+=1
 assert_gt(inside,0);assert_eq(outside,0)
func test_galaxy_parent_finish_inherits_explicitly()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();c.find("trial_b").traits.finish="galaxy"
 assert_eq(c.preview("trial_a","trial_b",{"finish":1}).finish,"galaxy")
 assert_eq(c.preview("trial_a","trial_b",{"finish":0}).finish,"normal")
 assert_eq(c.preview("original","trial_b",{"finish":0}).finish,"normal")
 var h:Dictionary=c.breed("trial_a","trial_b",{"finish":1})
 assert_eq(h.traits.finish,"galaxy")
 var restored:=HorseCollection.new();assert_true(restored.restore(c.export_state()));assert_eq(restored.find(h.id).traits.finish,"galaxy")
func test_special_trial_selection_restores_real_collection()->void:
 var before:Dictionary=SaveData.horse_collection.export_state()
 SaveData.begin_trial_session()
 assert_true(SaveData.preview_trial_traits(19,9,5,21,"galaxy"))
 var t:Dictionary=SaveData.horse_collection.find("preview_temporary").traits
 assert_eq(t.eyes,21);assert_eq(t.pattern,9);assert_eq(t.finish,"galaxy")
 SaveData.end_trial_session()
 assert_eq(SaveData.horse_collection.export_state(),before)

func test_genetics_save_namespace_preserves_2_0_rollback()->void:
 var legacy:String="user://genetics_test_legacy.dat"
 var current:String="user://genetics_test_current.dat"
 for path in [legacy,current]:
  if FileAccess.file_exists(path):DirAccess.remove_absolute(path)
 var source:=ConfigFile.new();source.set_value("meta","version",2)
 var old:=HorseCollection.new();old.seed_trial();source.set_value("horses_trial","state",old.export_state());source.set_value("progress","highest_level_completed",3)
 assert_eq(source.save(legacy),OK)
 var bytes:PackedByteArray=FileAccess.get_file_as_bytes(legacy)
 var state=load("res://src/Application/save_data.gd").new()
 assert_ne(state.SAVE_PATH,state.LEGACY_2_SAVE_PATH)
 assert_eq(state.load_source_path(current,legacy),legacy)
 state.save_path=legacy;state.load_progress();assert_eq(state.highest_level_completed,3)
 state.save_path=current;state.horse_collection.find("original").traits.eyes=21;state.horse_collection.find("original").traits.pattern=9
 assert_true(state.save_progress());assert_eq(FileAccess.get_file_as_bytes(legacy),bytes)
 assert_eq(state.load_source_path(current,legacy),current)
 state.load_progress();assert_eq(state.horse_collection.find("original").traits.eyes,21)
 state.save_path=legacy;state.load_progress();assert_eq(HorseCollection.eye_index(state.horse_collection.find("original").traits),10)
 assert_eq(FileAccess.get_file_as_bytes(legacy),bytes)
 state.free()
 for path in [legacy,current]:DirAccess.remove_absolute(path)
