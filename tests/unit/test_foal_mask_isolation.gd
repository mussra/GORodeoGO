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
