class_name RegionalFlowerField123
extends Node2D
## Static shared field renderer using supplied flowers. No animation or per-frame scan.
const FLOWERS:Dictionary={
 "blue1":preload("res://art/world/cartoon/f_blue1.png"),"blue2":preload("res://art/world/cartoon/f_blue2.png"),
 "daisy1":preload("res://art/world/cartoon/f_daisy1.png"),"daisy2":preload("res://art/world/cartoon/f_daisy2.png"),
 "red1":preload("res://art/world/cartoon/f_red1.png"),"red2":preload("res://art/world/cartoon/f_red2.png"),
 "sun1":preload("res://art/world/cartoon/f_sun1.png"),"violet":preload("res://art/world/cartoon/f_violet.png"),
 "purple":preload("res://art/world/cartoon/f_purple.png"),"tulip1":preload("res://art/world/cartoon/f_tulip1.png")}
var flowers:Array=[]
static func plan(town_id:String,profile_id:String,seed_:int,center:Vector2)->Array:
 if not RegionalVillages123.PROFILES.has(profile_id):return []
 var palette:Array=RegionalVillages123.PROFILES[profile_id].flowers
 var rng=RandomNumberGenerator.new();rng.seed=hash(str(seed_)+":"+town_id+":field123-v1")
 var out:Array=[]
 for patch in (5 if palette.size()==1 else palette.size()):
  var col:int=patch%5;var row:int=patch/5
  var patch_center:Vector2=center+Vector2((col-2)*75,(row-.5)*100) if palette.size()>1 else center+Vector2((col-2)*75,0)
  for i in 12:
   var pos:Vector2=patch_center+Vector2(rng.randf_range(-28,28),rng.randf_range(-35,35))
   out.append({"id":"field123:"+town_id+":"+str(patch)+":"+str(i),"pos":pos,"type":palette[patch%palette.size()],"height":rng.randf_range(22,31)})
 return out
func _draw()->void:
 for f in flowers:
  var tex:Texture2D=FLOWERS[f.type];var h:float=f.height
  var w:float=h*tex.get_width()/float(tex.get_height())
  draw_texture_rect(tex,Rect2(f.pos-Vector2(w*.5,h),Vector2(w,h)),false)
