extends GutTest
func test_four_palettes_keep_alpha_eyes_muzzle_and_hooves():
 var source=load("res://art/foal/base.png");var before:Image=source.get_image()
 if before.is_compressed():before.decompress()
 for traits in [{"coat":10,"mane":0,"pattern":0,"legs":0,"eyes":10,"finish":"normal"},{"coat":6,"mane":4,"pattern":2,"legs":3,"eyes":10,"finish":"normal"},{"coat":18,"mane":1,"pattern":0,"legs":1,"eyes":10,"finish":"normal"},{"coat":3,"mane":5,"pattern":11,"legs":5,"eyes":10,"finish":"normal"}]:
  var result=HorseAppearance.texture(source,"foal",0,traits).get_image()
  var alpha_errors:int=0
  for y in before.get_height():
   for x in before.get_width():
    if before.get_pixel(x,y).a!=result.get_pixel(x,y).a:alpha_errors+=1
  assert_eq(alpha_errors,0)
  for p in [Vector2i(270,155),Vector2i(270,172),Vector2i(215,120),Vector2i(80,329),Vector2i(176,335)]:assert_eq(result.get_pixelv(p),before.get_pixelv(p),"Protected muzzle, pupil or hoof")
func test_black_mane_and_socks_are_warm_charcoal_not_blue():
 var t={"coat":10,"mane":0,"pattern":0,"legs":0,"eyes":10,"finish":"normal"}
 var result=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,t).get_image()
 for p in [Vector2i(195,43),Vector2i(130,150),Vector2i(35,225),Vector2i(171,310)]:
  var c:Color=result.get_pixelv(p);assert_gte(c.r,c.b);assert_lt(c.r,.28)
