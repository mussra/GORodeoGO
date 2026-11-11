extends GutTest
func test_all_45_head_frames_have_no_low_alpha_fringe_and_side8_dot_removed():
 for view in ["side","down","up","diag_down","diag_up"]:
  for i in 9:
   var image=load("res://art/experimental/pixellab/rider/%s/frame_%02d.png"%[view,i]).get_image()
   if image.is_compressed():image.decompress()
   var bad=0
   for y in 32:
    for x in image.get_width():
     var a=image.get_pixel(x,y).a
     if a>0 and a<=8.01/255:bad+=1
   assert_eq(bad,0,view+str(i))
 var image=load("res://art/experimental/pixellab/rider/side/frame_08.png").get_image()
 if image.is_compressed():image.decompress()
 assert_eq(image.get_pixel(59,10).a,0.0)
