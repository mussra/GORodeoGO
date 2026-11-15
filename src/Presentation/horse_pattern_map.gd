class_name HorsePatternMap
extends RefCounted
const GIRAFFE=preload("res://art/patterns/giraffe.png")
const COW=preload("res://art/patterns/cow.png")
const ZEBRA=preload("res://art/patterns/zebra.png")
const WILD238=preload("res://art/patterns/wild238.png")
static var wild_image238:Image
static var images:Dictionary={}
static func coverage(p:Vector2,pattern:int)->float:
 if pattern>=12 and pattern<=17:
  if wild_image238==null:
   wild_image238=WILD238.get_image()
   if wild_image238.is_compressed():wild_image238.decompress()
  var u:float=clampf((p.x-28.8)/96.0,0.,.999)
  var v:float=clampf(p.y/100.8,0.,.999)
  return wild_image238.get_pixel((pattern-12)*512+int(u*512),int(v*512)).r
 if not images.has(pattern):
  var image:Image=(GIRAFFE if pattern==10 else (COW if pattern==11 else ZEBRA)).get_image()
  if image.is_compressed():image.decompress()
  images[pattern]=image
 var image:Image=images[pattern]
 return image.get_pixel(posmod(int(floor(p.x/96.0*image.get_width())),image.get_width()),posmod(int(floor(p.y/96.0*image.get_height())),image.get_height())).r
static func color_at238(traits:Dictionary,p:Vector2)->Color:
 if traits.get("spots_style238","")=="rainbow":return HorseAppearance.soft_rainbow(clampf((p.y/100.8-.06)/.9,0.,1.))
 return color(traits)
static func color(traits:Dictionary)->Color:
 var index:=HorseCollection.spots_index(traits)
 if index>=0:return Color(HorseAppearance.COLORS[index])
 return Color("975936") if int(traits.get("pattern",0))==10 else (Color("273440") if int(traits.get("pattern",0))==11 or int(traits.get("pattern",0))>=12 else Color("f4edd8"))
