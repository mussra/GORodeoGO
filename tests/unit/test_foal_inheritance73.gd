extends GutTest
func test_selected_parent_legs_in_preview_and_birth():
 var c=HorseCollection.new();c.seed_trial();c.add_trial_parents()
 c.find("trial_a").traits["legs"]=1;c.find("trial_b").traits["legs"]=0
 for choice in [0,1]:
  var t=c.preview("trial_a","trial_b",{"legs":choice})
  assert_eq(t.legs,1 if choice==0 else 0)
  var child=c.breed("trial_a","trial_b",{"legs":choice});assert_eq(child.traits.legs,t.legs)
  var img=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,t).get_image()
  var p=img.get_pixel(171,310)
  if choice==0:assert_gt(p.r,.6)
  else:assert_lt(p.r,.3)
func test_natural_legs_do_not_keep_brown_source_socks():
 var t={"coat":18,"mane":4,"pattern":3,"finish":"normal"}
 var img=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,t).get_image()
 var p=img.get_pixel(171,310);assert_gt(p.r,.6);assert_gt(p.g,.5);assert_gt(p.b,.45)
 var original=load("res://art/foal/base.png").get_image();if original.is_compressed():original.decompress()
 for pos in [Vector2i(270,155),Vector2i(270,172),Vector2i(215,120),Vector2i(80,329),Vector2i(176,335)]:assert_eq(img.get_pixelv(pos),original.get_pixelv(pos))
func test_shared_portrait_has_centered_aspect_and_clears_adult_material():
 var v=TextureRect.new();HorsePortrait.apply(v,{"coat":18,"mane":1,"pattern":0})
 HorsePortrait.apply_horse(v,{"stage":"foal","traits":{"coat":18,"mane":1,"pattern":0,"finish":"normal"}})
 assert_null(v.material);assert_eq(v.stretch_mode,TextureRect.STRETCH_KEEP_ASPECT_CENTERED);assert_eq(v.texture_filter,CanvasItem.TEXTURE_FILTER_LINEAR);v.free()
