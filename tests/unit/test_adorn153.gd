extends GutTest
func test_original_unknown_and_two_metals_use_one_shader():
 for i in 3:
  var m:=AdornStudy153.material(AdornStudy153.IDS[i]);assert_eq(m.get_shader_parameter("metal"),i);assert_same(m.shader,AdornStudy153.SHADER)
 assert_eq(AdornStudy153.material("unapproved").get_shader_parameter("metal"),0)
func test_nine_frames_and_masks_are_cached_without_touching_source_textures():
 AdornStudy153.cache.clear()
 for style in AdornStudy153.IDS:
  for i in 9:
   assert_eq(AdornStudy153.frame(i).resource_path,"res://art/experimental/pixellab/rider/side/frame_%02d.png"%i)
   assert_same(AdornStudy153.material(style,i),AdornStudy153.material(style,i+9))
 assert_eq(AdornStudy153.cache.size(),27)
func test_source_hashes_unchanged_and_semantic_masks_cannot_expand_silhouette():
 var rows:Array=JSON.parse_string(FileAccess.get_file_as_string("res://art/adorn153/audit.json"));assert_eq(rows.size(),10)
 for row in rows:
  assert_eq(FileAccess.get_sha256("res://"+row.source),row.sha256)
  var source:=_image("res://"+row.source);var mask:=_image("res://"+row.mask);assert_eq(source.get_size(),mask.get_size());var legs:int=0;var boots:int=0;var invalid:int=0
  for y in mask.get_height():
   for x in mask.get_width():
    var pixel:=mask.get_pixel(x,y);var base:=source.get_pixel(x,y)
    if pixel.r>.1:legs+=1
    if pixel.g>.1:boots+=1
    if (maxf(pixel.r,pixel.g)>.1 and base.a==0.) or pixel.b>.01 or (pixel.r>.1 and pixel.g>.1):invalid+=1
  assert_eq(invalid,0,row.mask);assert_eq(legs,int(row.leg_pixels));assert_eq(boots,int(row.boot_pixels));assert_gt(legs,0);assert_gt(boots,0)
func test_side_leg_masks_are_only_lower_reviewed_coat_and_boots_avoid_coat_and_mane():
 for i in 9:
  var mask:=_image("res://art/adorn153/side_%02d.png"%i);var coat:=_image("res://art/experimental/pixellab_masks_review_v5/rider/side/color_%02d.png"%i);var bad:int=0
  for y in 96:
   for x in 96:
    var p:=mask.get_pixel(x,y);var c:=coat.get_pixel(x,y)
    if p.r>.1 and (y<=67 or c.r<.39 or c.g>.39):bad+=1
    if p.g>.1 and (y<56 or y>71 or c.r>.39 or c.g>.39):bad+=1
  assert_eq(bad,0,"pose %d"%i)

func _image(path:String)->Image:return (load(path) as Texture2D).get_image()
