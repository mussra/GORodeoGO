extends GutTest
func before_each()->void:
 pass

func test_genotype_color_and_mask_gate()->void:
 var t={"coat":3,"mane":4,"pattern":0,"finish":"matte"}
 var base:Texture2D=load("res://art/experimental/pixellab/horse/side/frame_00.png")
 var recolored=PixelLabTrial.pose_texture("horse","side",0,t)
 assert_ne(recolored,base)
 var m:Image=load("res://art/experimental/pixellab_masks_review_v5/horse/side/color_00.png").get_image();m.decompress()
 var a=base.get_image();a.decompress();var b=recolored.get_image();b.decompress()
 var count:int=0;var unchanged:int=0
 for y in 96:
  for x in 96:
   if m.get_pixel(x,y).r>.5:
    count+=int(b.get_pixel(x,y).b>b.get_pixel(x,y).r)
   elif m.get_pixel(x,y).g<.1:unchanged+=int(a.get_pixel(x,y)==b.get_pixel(x,y))
 assert_gt(count,300);assert_gt(unchanged,5000)

 assert_eq(PixelLabTrial.pose_texture("horse","side",0,t),recolored)
func test_keys_stable_and_shared_frame_count()->void:
 var t={"coat":1,"mane":0,"pattern":11,"spots":0,"finish":"matte"}
 var on=PixelLabTrial.cache_key(t);assert_eq(on,PixelLabTrial.cache_key(t));
 var f=SpriteFrames.new();PixelLabTrial.apply(f,"horse","walk",t)
 for anim in ["walk","walk_down","walk_up","walk_diag_down","walk_diag_up"]:assert_eq(f.get_frame_count(anim),9)
 assert_eq(f.get_frame_texture("idle",0),f.get_frame_texture("walk",0))
func test_original_finish_preserved()->void:
 var t={"coat":3,"mane":4,"pattern":11,"finish":"original"}
 assert_eq(PixelLabTrial.pose_texture("horse","down",0,t),load("res://art/experimental/pixellab/horse/down/frame_00.png"))
