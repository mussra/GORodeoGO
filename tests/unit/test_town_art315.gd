extends GutTest
func texture_image(texture:Texture2D)->Image:
 var im:=texture.get_image()
 if im.is_compressed():im.decompress()
 return im
func test_tint_preserves_alpha_and_wood_but_uses_town_base():
 var look:Dictionary={"base":"2288cc","spot":"ee5555","pattern":0}
 var source:=texture_image(TownArt315.LEFT)
 var result:=texture_image(TownArt315.painted(true,look))
 assert_eq(result.get_size(),source.get_size())
 assert_eq(result.get_pixel(60,25),source.get_pixel(60,25),'Wood cap unchanged')
 assert_eq(result.get_pixel(60,280),source.get_pixel(60,280),'Wood plinth unchanged')
 assert_eq(result.get_pixel(0,150).a,source.get_pixel(0,150).a,'Silhouette alpha unchanged')
 assert_gt(result.get_pixel(60,150).b,result.get_pixel(60,150).r,'Town blue remains blue')
func test_pattern_and_spot_are_not_replaced_by_neutral_stone():
 var solid:Dictionary={"base":"eeccaa","spot":"cc2233","pattern":0}
 var striped:Dictionary=solid.duplicate();striped.pattern=9
 var a:=texture_image(TownArt315.painted(false,solid));var b:=texture_image(TownArt315.painted(false,striped))
 var different:int=0
 for y in range(60,246):
  for x in range(10,115):
   if a.get_pixel(x,y)!=b.get_pixel(x,y):different+=1
 assert_gt(different,100,'Horse-derived town pattern is retained')
 assert_eq(a.get_pixel(60,25),b.get_pixel(60,25),'Pattern cannot repaint wood')
func test_masks_are_separate_and_source_is_not_mutated():
 var before:=texture_image(TownArt315.LEFT).get_data().hex_encode().sha256_text()
 TownArt315.painted(true,{"base":"aa11aa","spot":"11cc11","pattern":6})
 assert_eq(texture_image(TownArt315.LEFT).get_data().hex_encode().sha256_text(),before)
 var mask:=texture_image(TownArt315.MASK_LEFT)
 assert_eq(mask.get_pixel(60,25).a,0.)
 assert_gt(mask.get_pixel(60,150).a,.95)
 assert_eq(mask.get_pixel(60,280).a,0.)
