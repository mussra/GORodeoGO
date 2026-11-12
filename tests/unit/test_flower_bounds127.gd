extends GutTest
const Scene=preload("res://tools/qa_flower_fields126.gd")
func test_seeded_organic_perimeter_preserves_full_core_chunks():
 var scene=Scene.new() # No tree insertion, so QA scene never runs or writes files.
 for i in 2:
  var polygon=scene.boundary127(i)
  assert_eq(polygon,scene.boundary127(i))
  var core:Rect2=scene.FIELDS[i]
  for x in range(0,2049,128):
   for y in range(0,1025,128):assert_true(Geometry2D.is_point_in_polygon(core.position+Vector2(x,y),polygon))
  assert_gt(polygon.size(),4)
  assert_ne(polygon[0].y,polygon[1].y,"Not a rectangle aligned to chunk edges")
 assert_ne(scene.boundary127(0),scene.boundary127(1))
 scene.free()
