extends GutTest
func test_removed_matte_stays_transparent_with_user_masks()->void:
 var audit=JSON.parse_string(FileAccess.get_file_as_string("res://tools/hat_cleanup_2768.json"))

 var count:int=0
 for entry in audit:
  var bits=entry.path.split("/");var view=bits[4];var frame=int(bits[5].trim_prefix("frame_").trim_suffix(".png"))
  var image=PixelLabTrial.pose_texture("rider",view,frame,{"coat":1,"pattern":9,"spots":5,"mane":5,"finish":"matte"}).get_image()
  if image.is_compressed():image.decompress()
  for p in entry.pixels:
   assert_eq(image.get_pixel(int(p[0]),int(p[1])).a,0.0,view+str(frame)+str(p.slice(0,2)));count+=1
 assert_eq(count,2410)
