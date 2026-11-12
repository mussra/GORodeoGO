extends GutTest
func test_three_studies_are_explicit_and_unknown_is_pass_through():
 assert_eq(SpecialFinish145.IDS,["gold","crystal","ice"])
 for i in 3:
  var m:=SpecialFinish145.material(SpecialFinish145.IDS[i],HorsePortrait.MASK)
  assert_eq(m.get_shader_parameter("style"),i+1)
  assert_eq(m.get_shader_parameter("region_mask"),HorsePortrait.MASK)
  assert_false(m.get_shader_parameter("uv_enabled"))
 assert_eq(SpecialFinish145.material("not-a-finish",HorsePortrait.MASK).get_shader_parameter("style"),0)
func test_nine_frames_wrap_reuse_materials_and_preserve_base_assets():
 SpecialFinish145.frame_cache.clear()
 for style in SpecialFinish145.IDS:
  for i in 9:
   var frame:=SpecialFinish145.riderless_frame(i)
   assert_eq(frame.resource_path,"res://art/experimental/pixellab/horse/side/frame_%02d.png"%i)
   var m:=SpecialFinish145.frame_material(style,i)
   assert_same(m,SpecialFinish145.frame_material(style,i+9))
   assert_true(m.get_shader_parameter("uv_enabled"))
 assert_eq(SpecialFinish145.frame_cache.size(),27)
