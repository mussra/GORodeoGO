extends GutTest
func test_cropped_sheet_all_eight_textures_have_transparent_corners():
 for index in 4:
  for orientation in ["horizontal","vertical"]:
   var texture:Texture2D=load("res://art/memory208/%d-%s.png"%[index+1,orientation]);var image:=texture.get_image()
   if image.is_compressed():image.decompress()
   assert_lt(image.get_pixel(0,0).a,.1)
   assert_gt(image.get_width(),50);assert_gt(image.get_height(),100)
func test_visual_collision_and_scoring_axes_agree():
 for index in 4:
  var fence:=MemoryFence208.new();fence.index=index;add_child_autofree(fence)
  var shape:RectangleShape2D=fence.get_child(0).get_child(0).shape
  assert_eq(shape.size,Vector2(151,8))
  assert_true(fence.get_node("FenceArt").texture.resource_path.ends_with("%d-horizontal.png"%[index+1]))
  assert_eq(MemoryFence208.half_axis(index),Vector2(75,0))
  assert_almost_eq(MemoryFence208.half_axis(index).dot(MemoryFence208.normal(index)),0.,.001)
