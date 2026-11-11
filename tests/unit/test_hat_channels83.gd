extends GutTest
func test_all_nominal_views_hat_recolor_only_inside_new_channel():
 var old_hat=SaveData.hat_color
 for view in ["side","down","up","diag_down","diag_up"]:
  for i in 9:
   var mask:Image=load("res://art/hat_masks_v10/hat-pixellab-%s-%02d.png"%[view,i]).get_image()
   var base:Texture2D=load("res://art/experimental/pixellab/rider/%s/frame_%02d.png"%[view,i])
   var before=base.get_image();var original=before.get_data()
   assert_same(HatAppearance.tint(base,"res://art/hat_masks_v10/hat-pixellab-%s-%02d.png"%[view,i],"original"),base)
   for hat in ["blue","sand"]:
    SaveData.hat_color=hat
    var after=PixelLabTrial.pose_texture("rider",view,i,{}).get_image();var changed:int=0;var outside:int=0
    for y in 96:
     for x in 96:
      if before.get_pixel(x,y)!=after.get_pixel(x,y):
       changed+=1
       if mask.get_pixel(x,y).b==0:outside+=1
    assert_gt(changed,50);assert_eq(outside,0)
   assert_eq(before.get_data(),original)
 SaveData.hat_color=old_hat
func test_classic_shared_tint_and_drink_and_portrait_have_masks():
 for path in ["hat-drink-0","hat-drink-1","hat-portrait","hat-classic-idle-frame_00","hat-classic-jump_side-frame_00","hat-classic-stunned-frame_0"]:
  assert_true(ResourceLoader.exists("res://art/hat_masks_v10/"+path+".png"),path)
