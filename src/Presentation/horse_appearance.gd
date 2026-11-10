class_name HorseAppearance
extends RefCounted
const COLORS=["273440","e9e2d3","dda92c","246bc5","398c54","bd3e3e","8550ad","27a6a0","d45f9d","e07730","975936","8b96a0","e3c388","bb6d45","9db543","334b84","a192d1","dc7972","72b7de","774c77"]
const MANES=["222c37","fff3d3","f0ba2e","347ef0","e04c52"]
const FOAL_EYES=preload("res://art/foal/eyes.png")
static var cache:Dictionary={}
static var body_offsets:Dictionary={}
static var hat_pixels:Dictionary={}
static var pose_uv_cache:Dictionary={}
static func pose_uv(anim:String,frame:int)->Image:
 var id:String=anim+str(frame)
 if pose_uv_cache.has(id):return pose_uv_cache[id]
 var path:String="res://art/horse_pose_uv/%s/frame_%02d.png"%[anim,frame]
 var uv:Image=null
 if ResourceLoader.exists(path):
  uv=load(path).get_image()
  if uv.is_compressed():uv.decompress()
 pose_uv_cache[id]=uv
 return uv
static func body_point(uv:Image,x:int,y:int,bob:int)->Vector2:
 if uv!=null:
  var sample:Color=uv.get_pixel(x,y)
  return Vector2(sample.r,sample.g)*127.5
 return Vector2(x,y-bob)

static func protected_hat(anim:String,frame:int)->Dictionary:
 var id:String=anim+str(frame)
 if hat_pixels.has(id):return hat_pixels[id]
 var pixels:Dictionary={}
 var original_path:String="res://art/player/%s/frame_%02d.png"%[anim,frame]
 var blue_path:String="res://art/player_hats/blue/%s/frame_%02d.png"%[anim,frame]
 if ResourceLoader.exists(original_path) and ResourceLoader.exists(blue_path):
  var original:Image=load(original_path).get_image();var blue:Image=load(blue_path).get_image()
  if original.is_compressed():original.decompress()
  if blue.is_compressed():blue.decompress()
  for y in range(mini(23,original.get_height())):
   for x in range(28,mini(73,original.get_width())):
    if original.get_pixel(x,y)!=blue.get_pixel(x,y):pixels[Vector2i(x,y)]=true
 hat_pixels[id]=pixels;return pixels
static func body_offset(source:Image,anim:String,frame:int)->int:
 if anim=="foal" or frame==0:return 0
 var path:="res://art/player/%s/frame_00.png"%anim
 if not ResourceLoader.exists(path):return 0
 if not body_offsets.has(anim):
  var base:Image=load(path).get_image()
  if base.is_compressed():base.decompress()
  body_offsets[anim]=rider_top(base)
 return rider_top(source)-int(body_offsets[anim])
static func rider_top(image:Image)->int:
 for y in range(35):
  for x in range(28,73):
   if image.get_pixel(x,y).a>.5:return y
 return 0
# One deterministic, non-grid spot layout shared with the large portrait.
static var spot_layout:Array[Vector4]=[]
static func spots()->Array[Vector4]:
 if not spot_layout.is_empty():return spot_layout
 var rng:=RandomNumberGenerator.new();rng.seed=642601
 for attempt in range(3000):
  var center:=Vector2(rng.randf_range(0,128),rng.randf_range(0,104))
  var separate:bool=true
  for item in spot_layout:
   if center.distance_to(Vector2(item.x,item.y))<6.4:separate=false;break
  if separate:spot_layout.append(Vector4(center.x,center.y,rng.randf_range(.7,2.15),rng.randf_range(-.7,.7)))
  if spot_layout.size()>=128:break
 return spot_layout
static func natural_spot(p:Vector2)->bool:
 return natural_spot_coverage(p)>.5
static func natural_spot_coverage(p:Vector2)->float:
 var coverage:float=0.0
 for item in spots():
  var q:Vector2=(p-Vector2(item.x,item.y)).rotated(item.w)
  var edge:float=maxf(absf(q.x)-item.z,absf(q.y)-item.z*.85)
  if edge>.5:continue
  coverage=maxf(coverage,1.0-smoothstep(-.5,.5,edge))
  if coverage>=1.0:return coverage
 return coverage
# Pattern IDs 0..4 remain unchanged for existing saves. New shapes append at 5..9.
static func shape_point(q:Vector2,pattern:int)->bool:
 if pattern==5:
  q.y=-q.y+.25
  var a:float=q.x*q.x+q.y*q.y-1.0
  return a*a*a-q.x*q.x*q.y*q.y*q.y<0.0
 if pattern==6:
  var inside:bool=false
  var last:Vector2=Vector2(cos(-PI/2.0+9.0*PI/5.0),sin(-PI/2.0+9.0*PI/5.0))*.48
  for k in range(10):
   var angle:float=-PI/2.0+k*PI/5.0
   var v:Vector2=Vector2(cos(angle),sin(angle))*(1.2 if k%2==0 else .48)
   if (v.y>q.y)!=(last.y>q.y) and q.x<(last.x-v.x)*(q.y-v.y)/(last.y-v.y)+v.x:inside=not inside
   last=v
  return inside
 if pattern==7:return q.y>-.95 and q.y<.95 and absf(q.x)<(q.y+.95)*.58
 if pattern==8:return absf(q.x)*.8+absf(q.y)<1.12
 return absf(q.x)<1.0 and absf(q.y)<.85
static func genetic_mark(p:Vector2,pattern:int)->bool:
 if pattern in [9,10,11]:return HorsePatternMap.coverage(p,pattern)>.5
 for item in spots():
  var q:Vector2=(p-Vector2(item.x,item.y)).rotated(item.w)/item.z
  if q.length_squared()>3.5:continue
  if shape_point(q,pattern):return true
 return false
static func soft_rainbow(t:float)->Color:
 var palette:Array[Color]=[Color("ec606c"),Color("efb85d"),Color("e8d874"),Color("77c888"),Color("6aa9da"),Color("9980c8"),Color("ec606c")]
 var u:float=clampf(t,0.0,.999)*6.0
 return palette[int(u)].lerp(palette[mini(int(u)+1,6)],smoothstep(0.0,1.0,u-floorf(u)))
static func galaxy_color(p:Vector2)->Color:
 var wave:float=(sin(p.x*.22+p.y*.12)+cos(p.y*.29-p.x*.09)+2.0)/4.0
 var neb:float=exp(-pow((p.y-(.45*p.x+21.0))/9.0,2.0))
 var color:=Color((30+105*wave+45*neb)/255.0,(28+40*wave+60*neb)/255.0,(80+100*wave+55*neb)/255.0)
 for star in [Vector2(27,48),Vector2(32,60),Vector2(60,56),Vector2(69,38),Vector2(77,45),Vector2(62,65),Vector2(24,69),Vector2(72,67),Vector2(53,73),Vector2(67,28)]:
  if p.distance_to(star)<.5:return Color("f4f7ff")
 return color
static func eye_color_at(index:int,p:Vector2)->Color:
 if index<20:return Color(COLORS[clampi(index,0,19)])
 if index==20:return soft_rainbow(p.y)
 # Small fixed nebula and stars, no animation or change outside the iris mask.
 var wave:float=(sin(p.x*10+p.y*5)+cos(p.y*13-p.x*4)+2.0)/4.0
 var color:=Color(.12+.40*wave,.08+.22*wave,.35+.42*wave)
 for star in [Vector2(.25,.25),Vector2(.65,.38),Vector2(.42,.72),Vector2(.78,.75)]:
  if p.distance_to(star)<.022:return Color("f4f7ff")
 return color
static func texture(source:Texture2D,anim:String,frame:int,t:Dictionary,mask_override:Image=null,uv_override:Image=null)->Texture2D:
 if t.get("finish","")=="original" and not t.has("emblem") and HorseCollection.legs_index(t)<0:return source
 var key:String=source.resource_path+str(t)+(":pixellab-v5" if mask_override!=null else "")
 if cache.has(key):return cache[key]
 var path:String="res://art/horse_masks/%s/frame_%02d.png"%[anim,frame]
 if anim=="stunned":path="res://art/horse_masks/stunned/frame_0.png"
 if mask_override==null and not ResourceLoader.exists(path):return source
 var mask:Image=mask_override if mask_override!=null else load(path).get_image();var image:Image=source.get_image().duplicate()
 if image.is_compressed():image.decompress()
 if mask.is_compressed():mask.decompress()
 var bob:int=0 if mask_override!=null else body_offset(image,anim,frame)
 var uv:Image=uv_override if mask_override!=null else pose_uv(anim,frame)
 var hat:Dictionary=protected_hat(anim,frame) if mask_override==null and anim in ["walk_diag_down","walk_diag_up"] else {}
 for y in range(image.get_height()):
  for x in range(image.get_width()):
   var m:Color=mask.get_pixel(x,y)
   # Horse masks previously touched the hat in downward-diagonal frames 8-11.
   # Hat exclusion follows the same airborne bob as the source; a fixed row
   # clipped the horse forehead in raised phases.
   if mask_override==null and anim in ["walk_diag_down","walk_diag_up"] and ((y<23+bob and x>=28 and x<=72) or hat.has(Vector2i(x,y))):continue
   if t.get("finish","")=="original":continue
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
    else:color=Color("33302e") if anim=="foal" and int(t.mane)==0 else Color(MANES[int(t.mane)])
   elif int(t.pattern)>0:
    var mark:bool=false
    var point:Vector2=body_point(uv,x,y,bob) if int(t.pattern) not in [3,4] else Vector2(x,y-bob)
    var px:float=float(x)*96.0/image.get_width() if anim=="foal" else point.x
    var py:float=float(y)*96.0/image.get_height() if anim=="foal" else point.y
    match int(t.pattern):
     1:
      if anim=="walk_diag_down" and uv==null:mark=(Vector2(px,py)-Vector2(32,51)).length()<7 or (Vector2(px,py)-Vector2(58,61)).length()<6
      else:mark=(Vector2(px,py)-Vector2(30,60)).length()<8 or (Vector2(px,py)-Vector2(58,68)).length()<6
     2:mark=natural_spot(Vector2(px,py)) if uv==null else false
     3:mark=px<40 and py>48 and py<78
     4:mark=py>77
     5,6,7,8,9,10,11:mark=genetic_mark(Vector2(px,py),int(t.pattern))
    if anim=="foal" and int(t.pattern)==1:
     var dist:float=minf((Vector2(px,py)-Vector2(30,60)).length()-8.0,(Vector2(px,py)-Vector2(58,68)).length()-6.0)
     color=color.lerp(Color("f4edd8"),1.0-smoothstep(-.9,.9,dist))
    elif int(t.pattern)==2 and uv!=null:color=color.lerp(HorsePatternMap.color(t),natural_spot_coverage(Vector2(px,py)))
    elif int(t.pattern) in [9,10,11]:color=color.lerp(HorsePatternMap.color(t),HorsePatternMap.coverage(Vector2(px,py),int(t.pattern)))
    elif mark:color=HorsePatternMap.color(t)
   if t.get("finish","")=="galaxy":color=galaxy_color(Vector2(float(x)*96.0/image.get_width(),float(y-bob)*96.0/image.get_height()))
   if anim=="foal":
    shade=clampf(maxf(old.r,maxf(old.g,old.b))*(1.0 if m.g>m.r else 1.10),0.12,1.0)
   var tinted:=Color(minf(color.r*shade,1),minf(color.g*shade,1),minf(color.b*shade,1),old.a)
   image.set_pixel(x,y,old.lerp(tinted,maxf(m.r,m.g)) if anim=="foal" else tinted)
 # Shared for levels, open world, riderless horses and foals. No per-frame work.
 if mask_override==null and (HorseCollection.legs_index(t)>=0 or anim=="foal") :
  var leg_path:String="res://art/lower_legs_masks/%s/frame_%02d.png"%[anim,frame]
  if anim=="stunned":leg_path="res://art/lower_legs_masks/stunned/frame_0.png"
  if ResourceLoader.exists(leg_path):
   var leg_mask:Image=load(leg_path).get_image()
   if leg_mask.is_compressed():leg_mask.decompress()
   var original:Image=source.get_image()
   if original.is_compressed():original.decompress()
   var leg_color:=Color("f4edd8") if HorseCollection.legs_index(t)<0 else (Color("33302e") if anim=="foal" and HorseCollection.legs_index(t)==0 else Color(COLORS[HorseCollection.legs_index(t)]))
   for ly in image.get_height():
    for lx in image.get_width():
     var coverage:float=leg_mask.get_pixel(lx,ly).r
     if anim!="foal" and int(t.pattern)==4 and ly-bob>77 and mask.get_pixel(lx,ly).r>.5:coverage=1.0
     if coverage<.01:continue
     var old:Color=original.get_pixel(lx,ly)
     var shade:float=clampf(maxf(old.r,maxf(old.g,old.b))/.83,.16,1.18)
     var colored:=Color(leg_color.r*shade,leg_color.g*shade,leg_color.b*shade,old.a)
     image.set_pixel(lx,ly,image.get_pixel(lx,ly).lerp(colored,coverage))
 if cache.size()>600:cache.clear()
 if anim=="foal" and t.has("eyes"):
  var eye_mask:Image=FOAL_EYES.get_image()
  if eye_mask.is_compressed():eye_mask.decompress()
  var eye_id:int=HorseCollection.eye_index(t)
  for y in image.get_height():
   for x in image.get_width():
    var weight:float=eye_mask.get_pixel(x,y).r
    if weight<.01:continue
    var eye:Color=eye_color_at(eye_id,Vector2((float(x)-202.0)/30.0,(float(y)-122.0)/23.0))
    var old:Color=image.get_pixel(x,y);var shade:=clampf(maxf(old.r,maxf(old.g,old.b))/.65,.15,1.15)
    image.set_pixel(x,y,old.lerp(Color(eye.r*shade,eye.g*shade,eye.b*shade,old.a),weight))
 if mask_override==null and HorseEmblem.valid(t.get("emblem")):
  var zone_path:String="res://art/lineage_masks/%s/frame_%02d.png"%[anim,frame]
  if ResourceLoader.exists(zone_path):
   var zone:Image=load(zone_path).get_image()
   if zone.is_compressed():zone.decompress()
   HorseEmblem.stamp(image,zone,t.emblem,mask)
 var tex:=ImageTexture.create_from_image(image);cache[key]=tex;return tex
static func apply(frames:SpriteFrames,t:Dictionary)->void:
 for anim in frames.get_animation_names():
  for i in range(frames.get_frame_count(anim)):
   frames.set_frame(anim,i,texture(frames.get_frame_texture(anim,i),anim,i,t))
