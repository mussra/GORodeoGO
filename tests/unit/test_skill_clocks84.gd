extends GutTest
func test_three_supplied_textures_have_transparent_outside_and_small_ui_size():
 assert_eq(RadialGauge.ART.size(),3)
 for skill in ["stamina","dodge","jump"]:
  var tex:Texture2D=RadialGauge.ART[skill]
  assert_eq(tex.get_size(),Vector2(256,256))
  var image=tex.get_image()
  for corner in [Vector2i(0,0),Vector2i(255,0),Vector2i(0,255),Vector2i(255,255)]:assert_eq(image.get_pixelv(corner).a,0.0)
  assert_gt(image.get_pixel(128,128).a,.9)
func test_states_remain_dynamic_and_unavailable_skill_hidden():
 var g=RadialGauge.new();add_child_autofree(g);g.size=Vector2(76,76)
 for value in [0.,.25,.5,.75,1.]:g.set_state(true,value);assert_eq(g.ratio,value);assert_true(g.visible)
 g.set_state(false,.5);assert_false(g.visible)
 g.set_state(true,2.);assert_eq(g.ratio,1.)
 g.set_state(true,-1.);assert_eq(g.ratio,0.)
