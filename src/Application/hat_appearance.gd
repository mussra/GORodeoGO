class_name HatAppearance
extends RefCounted
## First cosmetic trial. Original is always available; no gameplay bonus or price.
const OPTIONS:Dictionary={"original":"Original","blue":"Azul noche","sand":"Arena"}
static func sanitize(value:Variant)->String:
 if typeof(value)!=TYPE_STRING:return "original"
 if OPTIONS.has(value):return value
 var parts:PackedStringArray=value.split(":")
 if parts.size()==4 and parts[0]=="hat" and parts[1]=="v1" and parts[2].is_valid_int() and parts[3].is_valid_int() and int(parts[2])>=0 and int(parts[2])<HorseAppearance.COLORS.size() and int(parts[3])>=0 and int(parts[3])<15:return value
 return "original"
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
 var settings:Dictionary=decode(id)
 var bounds:Rect2i=mask.get_used_rect()
 # Use occupied hat-mask bounds, not canvas dimensions, to keep detail visible.
 var first:Vector2i=Vector2i(image.get_size());var last:Vector2i=Vector2i.ZERO
 for y in image.get_height():
  for x in image.get_width():
   if mask.get_pixel(x,y).b>.01:first=first.min(Vector2i(x,y));last=last.max(Vector2i(x,y))
 bounds=Rect2i(first,(last-first+Vector2i.ONE).max(Vector2i.ONE))
 for y in range(bounds.position.y,bounds.end.y):
  for x in range(bounds.position.x,bounds.end.x):
   var weight=mask.get_pixel(x,y).b
   if weight<=0:continue
   var point:Vector2=Vector2(x-bounds.position.x,y-bounds.position.y)/Vector2(bounds.size)
   var c:Color=surface_color(settings,point)
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

static func encode(coat:int,finish:int)->String:return "hat:v1:%d:%d"%[clampi(coat,0,19),clampi(finish,0,14)]
static func decode(value:String)->Dictionary:
 var id:String=sanitize(value)
 if id.begins_with("hat:v1:"):
  var parts=id.split(":");return {"coat":int(parts[2]),"finish":int(parts[3])}
 return {"coat":-1,"finish":0,"legacy":id}
static func surface_color(settings:Dictionary,p:Vector2)->Color:
 var coat:int=int(settings.get("coat",-1));var finish:int=int(settings.get("finish",0))
 var base:Color=Color(HorseAppearance.COLORS[coat]) if coat>=0 else (Color("415c81") if settings.get("legacy","")=="blue" else Color("c8b994"))
 if finish==13:return HorseAppearance.rainbow_color113(p.y)
 if finish==14:return HorseAppearance.galaxy_color(p*Vector2(64,80))
 if finish>0:
  var point:Vector2=p*Vector2(64,80)+Vector2(12,12)
  var ink:bool=false
  if finish==1:ink=(p-Vector2(.3,.5)).length()<.25 or (p-Vector2(.75,.8)).length()<.23
  elif finish==2:ink=HorseAppearance.natural_spot(point)
  elif finish==3:ink=p.x<.35
  elif finish==4:ink=p.y>.75
  else:ink=HorseAppearance.genetic_mark(point,finish)
  if ink:
   var light:float=base.get_luminance()
   return Color(HorseAppearance.COLORS[0 if light>.4 else 1])
 return base
