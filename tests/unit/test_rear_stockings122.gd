extends GutTest
func test_all_ninety_poses_change_only_reviewed_hind_coat_and_preserve_alpha():
 SaveData.hat_color="original"
 for kind in ["rider","horse"]:
  for view in ["side","down","up","diag_down","diag_up"]:
   for frame in 9:
    var path="res://art/experimental/pixellab/%s/%s/frame_%02d.png"%[kind,view,frame]
    var rear=HorseAppearance.rear_mask122(path);assert_not_null(rear)
    var mask=load("res://art/experimental/pixellab_masks_review_v5/%s/%s/color_%02d.png"%[kind,view,frame]).get_image()
    var t={"coat":0,"pattern":3,"mane":5,"finish":"normal"}
    var a=PixelLabTrial.pose_texture(kind,view,frame,t).get_image();t.pattern=0
    var b=PixelLabTrial.pose_texture(kind,view,frame,t).get_image();var changed:int=0
    for y in 96:
     for x in 96:
      assert_eq(a.get_pixel(x,y).a,b.get_pixel(x,y).a)
      if a.get_pixel(x,y)!=b.get_pixel(x,y):
       changed+=1
       assert_gt(rear.get_pixel(x,y).r,0.)
       assert_gt(mask.get_pixel(x,y).r,mask.get_pixel(x,y).g,"Never recolor mane/rider")
    if view=="down":assert_eq(changed,0,"Front-facing hidden hind legs must not recolor forelegs")
    else:assert_gt(changed,15,"No disappearing stockings in folded gait phases")
func test_extra_pose_masks_and_user_custom_leg_override_exist():
 for path in ["res://art/foal/base.png","res://art/player/stunned/frame_0.png","res://art/player/idle/frame_00.png","res://art/experimental/drink_preview83/pose_0.png","res://art/experimental/drink_preview83/pose_1.png"]:assert_not_null(HorseAppearance.rear_mask122(path))
 for view in ["side","up","down","diag_up","diag_down"]:
  for frame in 8:assert_not_null(HorseAppearance.rear_mask122("res://art/player/jump_%s/frame_%02d.png"%[view,frame]))
 var t={"coat":0,"pattern":3,"mane":0,"legs":3,"finish":"normal"}
 var image=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,t).get_image()
 var lower=load("res://art/lower_legs_masks/foal/frame_00.png").get_image();var count_:int=0
 for y in image.get_height():
  for x in image.get_width():
   if lower.get_pixel(x,y).r>.95:
    var c=image.get_pixel(x,y);assert_gt(c.b,c.r,"Custom blue legs win over white pattern");count_+=1
 assert_gt(count_,0)
