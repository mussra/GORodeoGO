class_name NpcScale214
extends RefCounted
## Shared world-space sizes, based on visible pixels rather than PNG canvas size.
const ADULT:=92.0
const CHILD:=76.0
static var bounds:Dictionary={}
static func visible_bounds(texture:Texture2D)->Rect2:
 var key:Texture2D=texture
 if not bounds.has(key):
  var image:=texture.get_image()
  if image.is_compressed():image.decompress()
  bounds[key]=Rect2(image.get_used_rect())
 return bounds[key]
static func apply(figure:Node2D,texture:Texture2D,height:float=ADULT,reference_height:float=0.):
 var rect:=visible_bounds(texture)
 figure.scale=Vector2.ONE*height/maxf(reference_height if reference_height>0. else rect.size.y,1.)
 figure.set("offset",Vector2(texture.get_width()*.5-rect.get_center().x,texture.get_height()*.5-rect.end.y))
