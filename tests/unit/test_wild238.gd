extends GutTest
func traits(pattern:int=12)->Dictionary:return {"coat":12,"pattern":pattern,"spots":0,"mane":1,"finish":"normal","coat_style238":"rainbow","spots_style238":"rainbow"}
func test_ids_old_saves_and_validation():
 var c:=HorseCollection.new();c.seed_trial();var raw:Dictionary=c.export_state();assert_true(c.restore(raw));assert_eq(HorseCollection.PATTERNS.slice(9,12),["Cebra","Jirafa","Vaca"])
 for k in range(12,18):assert_true(c.valid_traits(traits(k)))
 var invalid:=traits();invalid.coat_style238="bad";assert_false(c.valid_traits(invalid));invalid=traits();invalid.pattern=18;assert_false(c.valid_traits(invalid))
func test_breeding_independent_styles_and_grouping():
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();c.find("trial_a").traits=traits();c.find("trial_b").traits={"coat":3,"pattern":17,"spots":2,"mane":0,"finish":"normal"}
 var t:=c.preview("trial_a","trial_b",{"coat":0,"pattern":1,"spots":1});assert_eq(t.coat_style238,"rainbow");assert_false(t.has("spots_style238"));assert_eq(t.pattern,17)
 var child:=c.breed("trial_a","trial_b",{});assert_true(c.valid_traits(child.traits));assert_eq(child.traits.spots_style238,"rainbow");var saved:Dictionary=c.export_state();assert_true(c.restore(saved));assert_eq(c.find(child.id).traits,child.traits)
 var a:Dictionary={"traits":traits()};var b:Dictionary=a.duplicate(true);b.traits.coat_style238="flat";assert_ne(HorseAppearanceGroups118.key(a),HorseAppearanceGroups118.key(b))
func test_historical_hats_no_collision():
 for p in range(12,18):
  var horse:Dictionary={"traits":traits(p)};var id:=HatDesigns235.from_horse(horse);assert_eq(HatAppearance.sanitize(id),id);assert_eq(HatAppearance.decode(id).finish,p+8);assert_eq(HatAppearance.decode(id).coat,20);assert_eq(HatAppearance.decode(id).spots,20)
 for id in ["hat:v2:3:13:0","hat:v2:3:14:0","hat:v1:3:13"]:assert_eq(HatAppearance.sanitize(id),id)
 var galaxy:Dictionary={"traits":{"coat":3,"pattern":0,"mane":1,"finish":"galaxy"}};assert_eq(HatAppearance.decode(HatDesigns235.from_horse(galaxy)).finish,14)
func test_all_patterns_palette_and_protected_pixels():
 for p in range(12,18):
  var hits:int=0
  for y in range(0,100,3):
   for x in range(29,125,3):
    if HorsePatternMap.coverage(Vector2(x,y),p)>.5:hits+=1
  assert_gt(hits,0);assert_lt(hits,900)
  for base in 21:
   for ink in 21:
    var t:=traits(p);t.coat=mini(base,19);t.spots=mini(ink,19);t.coat_style238="rainbow" if base==20 else "flat";t.spots_style238="rainbow" if ink==20 else "flat";assert_true(HorseCollection.new().valid_traits(t))
func test_all_gameplay_frames_do_not_touch_other_regions():
 var t:=traits()
 for kind in ["rider","horse"]:
  for view in ["side","down","up","diag_down","diag_up"]:
   for f in 9:
    var root:String="res://art/experimental/pixellab/"+kind+"/"+view+"/frame_%02d.png"%f
    var src:Image=load(root).get_image();var mask:Image=load("res://art/experimental/pixellab_masks_review_v5/%s/%s/color_%02d.png"%[kind,view,f]).get_image();var image:Image=PixelLabTrial.pose_texture(kind,view,f,t).get_image();var protected:int=0;var changed:int=0
    for y in src.get_height():
     for x in src.get_width():
      var m:=mask.get_pixel(x,y)
      if maxf(m.r,m.g)<.02 and src.get_pixel(x,y)!=image.get_pixel(x,y):protected+=1
      if m.r>.5 and src.get_pixel(x,y)!=image.get_pixel(x,y):changed+=1
    assert_eq(protected,0,root);assert_gt(changed,0,root)
func test_save_editor_style_and_hat_survive_reload_sale():
 var save=load("res://src/Application/save_data.gd").new();save.save_path="user://wild238-tests.cfg";save.debug_mode=true;save.horse_collection.seed_trial();save.horse_collection.add_trial_parents();assert_true(save.set_horse_pattern_color("trial_a","pattern",12));assert_true(save.set_horse_pattern_color("trial_a","coat",20));assert_true(save.set_horse_pattern_color("trial_a","spots",20))
 var h:Dictionary=save.horse_collection.find("trial_a");var id:=HatDesigns235.from_horse(h);assert_true(save.hat_designs235.has(id));assert_true(save.sell_market_horse("trial_a"));save.load_progress();assert_true(save._load_valid);assert_true(save.hat_designs235.has(id));assert_true(save.select_hat(id));save.free();DirAccess.remove_absolute("user://wild238-tests.cfg")

func test_six_shapes_all_views_drink_foal_protect_non_coat_regions():
 for pattern in range(12,18):
  for rainbow_base in [true,false]:
   var t:=traits(pattern);t.coat_style238="rainbow" if rainbow_base else "flat";t.spots_style238="flat" if rainbow_base else "rainbow"
   for view in ["side","down","up","diag_down","diag_up"]:
    var tex:Texture2D=PixelLabTrial.pose_texture("rider",view,4,t);assert_gt(tex.get_width(),0)
   for pose in 2:
    var src:Image=load(HorseDrink.BASE+"pose_%d.png"%pose).get_image();var mask:Image=load(HorseDrink.BASE+"color_%d.png"%pose).get_image();var img:Image=HorseDrink.texture(pose,t,"original").get_image();var outside:int=0;var changed:int=0
    for y in src.get_height():
     for x in src.get_width():
      var m:=mask.get_pixel(x,y)
      if maxf(m.r,m.g)<.02 and src.get_pixel(x,y)!=img.get_pixel(x,y):outside+=1
      if m.r>.5 and src.get_pixel(x,y)!=img.get_pixel(x,y):changed+=1
    assert_eq(outside,0);assert_gt(changed,0)
   var foal:Image=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,t).get_image();assert_gt(foal.get_height(),0)

func test_new_default_black_ink_matches_unlocked_hat():
 var t:Dictionary={"coat":0,"pattern":12,"mane":1,"finish":"normal"}
 assert_eq(HorsePatternMap.color(t),Color("273440"));assert_eq(HatAppearance.decode(HatDesigns235.from_horse({"traits":t})).spots,0)

func test_leopard239_filled_centers_and_palette():
 var cream:=Color(HorseAppearance.COLORS[12]);var brown:=HorsePatternMap.center_color239(cream)
 assert_lt(brown.r,cream.r);assert_lt(brown.g,cream.g);assert_lt(brown.b,cream.b)
 assert_gt(brown.r,brown.b)
 var centers:int=0;var outside:int=0
 for y in range(0,100,2):
  for x in range(29,125,2):
   var p:=Vector2(x,y)
   if HorsePatternMap.center239(p)>.9 and HorsePatternMap.coverage(p,12)<.1:
    centers+=1
    assert_eq(HatAppearance.surface_color({"coat":12,"finish":20,"spots":0},Vector2((x-28.8)/96.0,y/100.8)),cream.lerp(brown,HorsePatternMap.center239(p)))
   if HorsePatternMap.center239(p)<.01:outside+=1
 assert_gt(centers,30);assert_gt(outside,100)
 for i in 20:
  var base:=Color(HorseAppearance.COLORS[i]);assert_eq(HorsePatternMap.center_color239(base).a,base.a)
