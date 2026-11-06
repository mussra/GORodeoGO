class_name HorseAppearance
extends RefCounted
const COLORS=["273440","e9e2d3","dda92c","246bc5","398c54","bd3e3e","8550ad","27a6a0","d45f9d","e07730","975936","8b96a0","e3c388","bb6d45","9db543","334b84","a192d1","dc7972","72b7de","774c77"]
const MANES=["222c37","fff3d3","f0ba2e","347ef0","e04c52"]
static var cache:Dictionary={}
static func texture(source:Texture2D,anim:String,frame:int,t:Dictionary)->Texture2D:
 if t.get("finish","")=="original":return source
 var key:String=source.resource_path+str(t)
 if cache.has(key):return cache[key]
 var path:String="res://art/horse_masks/%s/frame_%02d.png"%[anim,frame]
 if anim=="stunned":path="res://art/horse_masks/stunned/frame_0.png"
 if not ResourceLoader.exists(path):return source
 var mask:Image=load(path).get_image();var image:Image=source.get_image()
 if image.is_compressed():image.decompress()
 if mask.is_compressed():mask.decompress()
 for y in range(image.get_height()):
  for x in range(image.get_width()):
   var m:Color=mask.get_pixel(x,y)
   if m.r<0.5 and m.g<0.5:continue
   var old:Color=image.get_pixel(x,y);var shade:float=clampf(maxf(old.r,maxf(old.g,old.b))*255.0/205.0,0.25,1.18)
   var color:Color=Color(COLORS[int(t.coat)])
   if m.g>0.5:
    color=Color.from_hsv(fposmod((y-25.0)/38.0,1.0),0.8,1.0) if int(t.mane)==5 else Color(MANES[int(t.mane)])
   elif int(t.pattern)>0:
    var mark:bool=false
    match int(t.pattern):
     1:mark=(Vector2(x,y)-Vector2(30,53)).length()<8 or (Vector2(x,y)-Vector2(58,66)).length()<6
     2:mark=(x%11<5 and y%12<5 and y>43 and y<72)
     3:mark=x<36 and y>42 and y<72
     4:mark=y>72
    if mark:color=Color("f4edd8")
   image.set_pixel(x,y,Color(minf(color.r*shade,1),minf(color.g*shade,1),minf(color.b*shade,1),old.a))
 if cache.size()>600:cache.clear()
 var tex:=ImageTexture.create_from_image(image);cache[key]=tex;return tex
static func apply(frames:SpriteFrames,t:Dictionary)->void:
 for anim in frames.get_animation_names():
  for i in range(frames.get_frame_count(anim)):
   frames.set_frame(anim,i,texture(frames.get_frame_texture(anim,i),anim,i,t))
