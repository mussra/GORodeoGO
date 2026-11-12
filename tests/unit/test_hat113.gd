extends GutTest
func test_all_colors_patterns_legacy_validation_and_save():
 var save=load("res://src/Application/save_data.gd").new();save.save_path="user://hat113.dat"
 for color in 20:
  for finish in [0,1,2,3,4,5,6,7,8,9,10,11,13,14]:
   var id:String=HatAppearance.encode(color,finish);assert_eq(HatAppearance.sanitize(id),id)
   assert_eq(HatAppearance.decode(id).coat,color);assert_eq(HatAppearance.decode(id).finish,finish)
 assert_true(save.select_hat(HatAppearance.encode(3,13)));save.load_progress();assert_eq(save.hat_color,HatAppearance.encode(3,13))
 assert_eq(HatAppearance.sanitize("hat:v1:20:0"),"original");assert_eq(HatAppearance.sanitize("hat:v1:1:99"),"original")
 save.free();DirAccess.remove_absolute("user://hat113.dat")
func test_tint_only_changes_mask_and_shared_colors_patterns():
 var src:Texture2D=load("res://art/experimental/pixellab/rider/side/frame_00.png");var mask_path:String="res://art/hat_masks_v10/hat-pixellab-side-00.png";var mask:Image=load(mask_path).get_image();var original:Image=src.get_image()
 for finish in [0,2,5,9,10,11,13,14]:
  var changed:Image=HatAppearance.tint(src,mask_path,HatAppearance.encode(3,finish)).get_image();var pixels:int=0
  for y in changed.get_height():
   for x in changed.get_width():
    if mask.get_pixel(x,y).b<=0.:assert_eq(changed.get_pixel(x,y),original.get_pixel(x,y))
    elif changed.get_pixel(x,y)!=original.get_pixel(x,y):pixels+=1
  assert_gt(pixels,0)
 assert_eq(HatAppearance.surface_color({"coat":3,"finish":0},Vector2(.5,.5)),Color(HorseAppearance.COLORS[3]))
 assert_eq(HatAppearance.surface_color({"coat":3,"finish":13},Vector2(.5,.5)),HorseAppearance.rainbow_color113(.5))
