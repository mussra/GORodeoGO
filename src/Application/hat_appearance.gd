class_name HatAppearance
extends RefCounted
## First cosmetic trial. Original is always available; no gameplay bonus or price.
const OPTIONS:Dictionary={"original":"Original","blue":"Azul noche","sand":"Arena"}
static func sanitize(value:Variant)->String:
 return value if typeof(value)==TYPE_STRING and OPTIONS.has(value) else "original"
static func art_root(value:Variant)->String:
 var id:String=sanitize(value)
 return "res://art/player/"  # one source, separate editable hat-only masks

static var texture_cache:Dictionary={}
static func tint(source:Texture2D,mask_path:String,value:Variant)->Texture2D:
 var id=sanitize(value)
 if id=="original" or not ResourceLoader.exists(mask_path):return source
 var key=str(source.get_instance_id())+mask_path+id
 if texture_cache.has(key):return texture_cache[key]
 var image=source.get_image().duplicate();var mask:Image=load(mask_path).get_image()
 if image.is_compressed():image.decompress()
 if mask.is_compressed():mask.decompress()
 var c=Color("415c81") if id=="blue" else Color("c8b994")
 for y in image.get_height():
  for x in image.get_width():
   var weight=mask.get_pixel(x,y).b
   if weight<=0:continue
   var old=image.get_pixel(x,y);var shade=clampf(maxf(old.r,maxf(old.g,old.b))/.65,.25,1.18)
   image.set_pixel(x,y,old.lerp(Color(c.r*shade,c.g*shade,c.b*shade,old.a),weight))
 var result=ImageTexture.create_from_image(image)
 if texture_cache.size()>900:texture_cache.clear()
 texture_cache[key]=result;return result
static func apply_classic(frames:SpriteFrames,value:Variant)->void:
 for animation in frames.get_animation_names():
  for i in frames.get_frame_count(animation):
   var name="frame_%02d"%i
   if animation=="stunned":name="frame_%d"%i
   var path="res://art/hat_masks_v10/hat-classic-%s-%s.png"%[animation,name]
   frames.set_frame(animation,i,tint(frames.get_frame_texture(animation,i),path,value))
