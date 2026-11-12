extends GutTest
func test_supplied_tree_has_transparent_holes_and_clears_approach_and_bank():
 var image:=Image.new();assert_eq(image.load_png_from_buffer(FileAccess.get_file_as_bytes("res://art/world/supplied/tree_of_life150.png")),OK);assert_eq(image.get_size(),Vector2i(1176,1008));assert_true(image.has_mipmaps()==false)
 var holes:int=0
 for y in range(250,600,5):
  for x in range(200,1000,5):
   if image.get_pixel(x,y).a<.02:holes+=1
 assert_gt(holes,100)
 for seed_ in [123,752026,999999]:
  var data:=CountryRoute146.plan(seed_);var art:Rect2=data.tree_art
  for path in [data.approach,data.bank]:
   for i in range(1,path.size()):
    var a:Vector2=path[i-1];var b:Vector2=path[i];var steps:int=ceili(a.distance_to(b)/24.)
    for j in range(steps+1):
     var point_:Vector2=a.lerp(b,float(j)/steps)
     if art.has_point(point_):
      var pixel:Vector2i=Vector2i((point_-art.position)/art.size*Vector2(image.get_size()))
      assert_lt(image.get_pixelv(pixel).a,.1,"Road remains outside the opaque root/canopy")
  assert_true(CountryRoute146.path_clear(data,data.approach));assert_true(CountryRoute146.path_clear(data,data.upstream))
  var root_pixel:Vector2i=Vector2i((data.roots-art.position)/art.size*Vector2(image.get_size()));assert_gt(image.get_pixelv(root_pixel).a,.5,"River ends under roots")
