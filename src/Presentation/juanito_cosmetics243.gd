class_name JuanitoCosmetics243
extends RefCounted
## Appearance only. Hat uses the existing pose-specific hat mask. The saddle
## cloth uses a small mask over the exposed horse body beside the saddle,
## protecting the rider, mane and legs. Textures cached by source and item.
static var cache:Dictionary={}
static func apply(frames:SpriteFrames)->void:
 var hat:String=EquipmentEffects.equipped_id("cosmetic_hat")
 var cloth:String=EquipmentEffects.equipped_id("cosmetic_blanket")
 if hat.is_empty() and cloth.is_empty():return
 for animation in frames.get_animation_names():
  var view:String="side"
  for direction in ["diag_down","diag_up","down","up","side"]:
   if str(animation).ends_with(direction):view=direction;break
  for i in frames.get_frame_count(animation):
   var source:Texture2D=frames.get_frame_texture(animation,i)
   var key:String=str(source.get_instance_id())+hat+cloth+animation+str(i)
   if cache.has(key):frames.set_frame(animation,i,cache[key]);continue
   var result:Texture2D=source
   var mask_path:String="res://art/hat_masks_v10/hat-classic-%s-frame_%02d.png"%[animation,i]
   if str(animation).begins_with("walk_"):mask_path="res://art/hat_masks_v10/hat-pixellab-%s-%02d.png"%[view,i%9]
   if str(animation) in ["idle","rest_gesture107"]:mask_path="res://art/hat_masks_v10/hat-drink-%d.png"%(0 if str(animation)=="idle" else 1)
   if str(animation)=="stunned":mask_path="res://art/hat_masks_v10/hat-classic-stunned-frame_0.png"
   if not hat.is_empty() and ResourceLoader.exists(mask_path) and load(mask_path).get_width()==result.get_width() and load(mask_path).get_height()==result.get_height():result=HatAppearance.tint(result,mask_path,"hat:v3:15:1:2" if hat.ends_with("deluxe") else "hat:v3:0:0:0")
   if not cloth.is_empty():
    result=cloth_texture(result,view,i%9,cloth.ends_with("deluxe"),animation)
   if cache.size()>500:cache.clear()
   cache[key]=result;frames.set_frame(animation,i,result)
static func cloth_texture(source:Texture2D,view:String,i:int,deluxe:bool,animation:String="walk_side")->Texture2D:
 var path:String="res://art/experimental/pixellab_masks_review_v5/rider/%s/color_%02d.png"%[view,i]
 if animation in ["idle","rest_gesture107"]:path="res://art/experimental/drink_preview83/color_%d.png"%(0 if animation=="idle" else 1)
 elif animation.begins_with("jump_") or animation=="stunned":path="res://art/horse_masks/%s/%s.png"%[animation,"frame_0" if animation=="stunned" else "frame_%02d"%i]
 if not ResourceLoader.exists(path):return source
 var mask:Image=load(path).get_image();var image:Image=source.get_image().duplicate()
 if image.is_compressed():image.decompress()
 if mask.is_compressed():mask.decompress()
 if image.get_size()!=mask.get_size():return source
 var regions:Array=[]
 match view:
  "side":regions=[Rect2i(33,46,9,14),Rect2i(42,59,13,4)]
  "down":regions=[Rect2i(32,44,9,10),Rect2i(55,44,9,10)]
  "up":regions=[Rect2i(32,43,9,11),Rect2i(55,43,9,11)]
  "diag_down":regions=[Rect2i(34,43,9,12)]
  "diag_up":regions=[Rect2i(36,47,14,10)]
 var base:Color=Color("274d78") if deluxe else Color("843b35")
 for region in regions:
  for y in range(region.position.y,mini(region.end.y,image.get_height())):
   for x in range(region.position.x,mini(region.end.x,image.get_width())):
    var offset_x:int=8 if animation in ["idle","rest_gesture107"] else 0
    x+=offset_x
    if x>=image.get_width():continue
    var m:Color=mask.get_pixel(x,y);var original:Color=image.get_pixel(x,y)
    if m.r<.7 or m.g>.3 or original.a<.5:continue
    var shade:float=clampf(maxf(original.r,maxf(original.g,original.b))/.65,.3,1.2)
    var color:Color=Color("e6bd68") if deluxe and posmod(x+y,8)==0 else base
    image.set_pixel(x,y,Color(color.r*shade,color.g*shade,color.b*shade,original.a))
 return ImageTexture.create_from_image(image)
