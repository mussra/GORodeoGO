extends GutTest
func test_mane_never_marks_foal_legs()->void:
 var m:Image=load("res://art/horse_masks/foal/frame_00.png").get_image()
 var invaded:int=0
 for y in range(int(m.get_height()*.8),m.get_height()):
  for x in range(int(m.get_width()*.34),m.get_width()):
   if m.get_pixel(x,y).g>.02:invaded+=1
 assert_eq(invaded,0,"Mane region must never invade legs")
func test_foal_forehead_follows_coat()->void:
 var t:Dictionary={"coat":6,"pattern":0,"mane":5,"finish":"normal"}
 var tex:Texture2D=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,t)
 var c:Color=tex.get_image().get_pixel(180,90)
 assert_gt(c.b,c.g,"Forehead must inherit purple, not remain fixed brown")
func test_foal_rump_is_hide_and_neck_curl_is_mane()->void:
 var m:Image=load("res://art/horse_masks/foal/frame_00.png").get_image()
 for p in [Vector2i(88,215),Vector2i(90,230),Vector2i(85,245)]:
  assert_lt(m.get_pixelv(p).g,.02,"Rump next to tail is coat")
 for p in [Vector2i(152,145),Vector2i(155,160),Vector2i(149,178)]:
  assert_gt(m.get_pixelv(p).g,.85,"Neck mane reaches its curled edge")
func test_pixellab_all_rider_views_protect_unmasked_pixels()->void:
 for view in ["side","down","up","diag_down","diag_up"]:
  for i in 9:
   var base=load("res://art/experimental/pixellab/rider/%s/frame_%02d.png"%[view,i]).get_image()
   var mask=load("res://art/experimental/pixellab_masks_review_v5/rider/%s/color_%02d.png"%[view,i]).get_image()
   var result=PixelLabTrial.pose_texture("rider",view,i,{"coat":3,"mane":5,"pattern":0,"finish":"normal"}).get_image()
   for im in [base,mask,result]:
    if im.is_compressed():im.decompress()
   var bad:int=0
   for y in base.get_height():
    for x in base.get_width():
     var c:Color=mask.get_pixel(x,y)
     if maxf(c.r,c.g)<.01 and result.get_pixel(x,y)!=base.get_pixel(x,y):bad+=1
   assert_eq(bad,0,"Sombrero, jinete y equipo no cambian fuera de máscara: "+view+str(i))
