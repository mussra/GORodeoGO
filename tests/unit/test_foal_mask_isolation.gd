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
func test_downward_diagonal_hat_unchanged_by_horse_traits()->void:
 var source:Texture2D=load("res://art/player_hats/blue/walk_diag_down/frame_08.png")
 var t:Dictionary={"coat":6,"pattern":0,"mane":5,"finish":"normal"}
 var result:Image=HorseAppearance.texture(source,"walk_diag_down",8,t).get_image()
 var before:Image=source.get_image()
 for p in [Vector2i(55,11),Vector2i(40,15),Vector2i(48,18)]:assert_eq(result.get_pixelv(p),before.get_pixelv(p),"Hat material and badge protected")
func test_foal_rump_is_hide_and_neck_curl_is_mane()->void:
 var m:Image=load("res://art/horse_masks/foal/frame_00.png").get_image()
 for p in [Vector2i(88,215),Vector2i(90,230),Vector2i(85,245)]:
  assert_lt(m.get_pixelv(p).g,.02,"Rump next to tail is coat")
 for p in [Vector2i(152,145),Vector2i(155,160),Vector2i(149,178)]:
  assert_gt(m.get_pixelv(p).g,.85,"Neck mane reaches its curled edge")
func test_adult_side_socks_never_receive_mane()->void:
 for i in range(12):
  var tex:Texture2D=load("res://art/player/walk_side/frame_%02d.png"%i)
  var source:Image=tex.get_image()
  var result:=HorseAppearance.texture(tex,"walk_side",i,{"coat":3,"pattern":0,"mane":5,"finish":"normal"}).get_image()
  for y in range(69,88):
   for x in range(19,29):
    var c:Color=source.get_pixel(x,y)
    if c.a>.9 and c.r>.6 and c.g>.5 and c.b>.4 and absf(c.r-c.b)<.3:
     assert_eq(result.get_pixel(x,y),c,"White rear sock stays unchanged frame%d"%i)
func test_diagonal_hat_pixels_unchanged_all_frames()->void:
 for anim in ["walk_diag_down","walk_diag_up"]:
  for i in range(12):
   var tex:Texture2D=load("res://art/player/%s/frame_%02d.png"%[anim,i])
   var src:Image=tex.get_image()
   var result:=HorseAppearance.texture(tex,anim,i,{"coat":3,"pattern":0,"mane":5,"finish":"normal"}).get_image()
   var bob:int=HorseAppearance.body_offset(src,anim,i)
   for y in range(23+bob):
    for x in range(28,73):assert_eq(result.get_pixel(x,y),src.get_pixel(x,y),"Hat exclusion follows airborne body")
   # Independently verify actual hat pixels using the reviewed blue-hat variant.
   var blue:Image=load("res://art/player_hats/blue/%s/frame_%02d.png"%[anim,i]).get_image()
   for y in range(23):
    for x in range(28,73):
     if blue.get_pixel(x,y)!=src.get_pixel(x,y):assert_eq(result.get_pixel(x,y),src.get_pixel(x,y),"Actual hat must not inherit mane")
