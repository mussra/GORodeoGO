extends GutTest
func test_alternative_does_not_replace_current_default():
 assert_false(WorldTerrainPreview92.alternative)
 assert_eq(WorldTerrainPreview92.GRASS.get_size(),Vector2(1024,1024))
 assert_true(WorldTerrainPreview92.PIECES.has("t"));assert_true(WorldTerrainPreview92.PIECES.has("cross"))
func test_two_supplied_crosses_have_four_ports_and_derived_tee_three():
 for name in ["cross","cross-second","tee"]:
  var image=load("res://art/world/alternative92/"+name+".png").get_image()
  var open=0
  for p in [Vector2i(96,0),Vector2i(191,96),Vector2i(96,191),Vector2i(0,96)]:
   if image.get_pixelv(p).a>.5:open+=1
  assert_eq(open,3 if name=="tee" else 4)
  assert_lt(image.get_pixel(0,0).a,.05,"checker background removed")
