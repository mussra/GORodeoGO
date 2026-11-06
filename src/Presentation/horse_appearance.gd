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
   # Horse masks previously touched the hat in downward-diagonal frames 8-11.
   # The hat ends at row21; these pixels must never inherit horse traits.
   if anim in ["walk_diag_down","walk_diag_up"] and y<23 and x>=28 and x<=72:continue
   if maxf(m.r,m.g)<0.02:continue
   var old:Color=image.get_pixel(x,y);var shade:float=clampf(maxf(old.r,maxf(old.g,old.b))*255.0/205.0,0.25,1.18)
   var color:Color=Color(COLORS[int(t.coat)])
   if m.g>m.r:
    if int(t.mane)==5:
     var palette:Array[Color]=[Color("ec606c"),Color("efb85d"),Color("e8d874"),Color("77c888"),Color("6aa9da"),Color("9980c8"),Color("ec606c")]
     var tpos:float
     if anim=="foal":tpos=(float(y)-165.0)/105.0 if x<110 else float(y)/180.0
     elif anim=="walk_up":tpos=(float(y)-48.0)/30.0
     elif x<40:
      if anim=="walk_diag_down":tpos=(float(y)-35.0)/30.0
      elif anim=="walk_diag_up":tpos=(float(y)-46.0)/33.0
      else:tpos=(float(y)-40.0)/36.0
     else:tpos=(float(y)-25.0)/28.0
     var u:float=clampf(tpos,0.0,.999)*6.0
     color=palette[int(u)].lerp(palette[mini(int(u)+1,6)],smoothstep(0.0,1.0,u-floorf(u)))
    else:color=Color(MANES[int(t.mane)])
   elif int(t.pattern)>0:
    var mark:bool=false
    var px:float=float(x)*96.0/image.get_width() if anim=="foal" else x
    var py:float=float(y)*96.0/image.get_height() if anim=="foal" else y
    match int(t.pattern):
     1:mark=(Vector2(px,py)-Vector2(30,60)).length()<8 or (Vector2(px,py)-Vector2(58,68)).length()<6
     2:mark=(int(px)%11<5 and int(py)%12<5 and py>48 and py<78)
     3:mark=px<40 and py>48 and py<78
     4:mark=py>77
    if anim=="foal" and int(t.pattern)==1:
     var dist:float=minf((Vector2(px,py)-Vector2(30,60)).length()-8.0,(Vector2(px,py)-Vector2(58,68)).length()-6.0)
     color=color.lerp(Color("f4edd8"),1.0-smoothstep(-.9,.9,dist))
    elif mark:color=Color("f4edd8")
   if anim=="foal":
    shade=clampf(maxf(old.r,maxf(old.g,old.b))*(1.0 if m.g>m.r else 1.10),0.12,1.0)
   var tinted:=Color(minf(color.r*shade,1),minf(color.g*shade,1),minf(color.b*shade,1),old.a)
   image.set_pixel(x,y,old.lerp(tinted,maxf(m.r,m.g)) if anim=="foal" else tinted)
 if cache.size()>600:cache.clear()
 var tex:=ImageTexture.create_from_image(image);cache[key]=tex;return tex
static func apply(frames:SpriteFrames,t:Dictionary)->void:
 for anim in frames.get_animation_names():
  for i in range(frames.get_frame_count(anim)):
   frames.set_frame(anim,i,texture(frames.get_frame_texture(anim,i),anim,i,t))
