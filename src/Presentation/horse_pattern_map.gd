class_name HorsePatternMap
extends RefCounted
const GIRAFFE=preload("res://art/patterns/giraffe.png")
const COW=preload("res://art/patterns/cow.png")
const ZEBRA=preload("res://art/patterns/zebra.png")
static var images:Dictionary={}
static func coverage(p:Vector2,pattern:int)->float:
 if not images.has(pattern):
  var image:Image=(GIRAFFE if pattern==10 else (COW if pattern==11 else ZEBRA)).get_image()
  if image.is_compressed():image.decompress()
  images[pattern]=image
 var image:Image=images[pattern]
 return image.get_pixel(posmod(int(floor(p.x/96.0*image.get_width())),image.get_width()),posmod(int(floor(p.y/96.0*image.get_height())),image.get_height())).r
static func color(traits:Dictionary)->Color:
 var index:=HorseCollection.spots_index(traits)
 if index>=0:return Color(HorseAppearance.COLORS[index])
 return Color("975936") if int(traits.get("pattern",0))==10 else (Color("273440") if int(traits.get("pattern",0))==11 else Color("f4edd8"))
