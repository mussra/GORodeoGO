class_name TownArt315
extends RefCounted
const LEFT=preload("res://art/town315/gate-left.png")
const RIGHT=preload("res://art/town315/gate-right.png")
const MASK_LEFT=preload("res://art/town315/gate-left-paint-mask.png")
const MASK_RIGHT=preload("res://art/town315/gate-right-paint-mask.png")
static var cache:Dictionary={}
static func painted(left:bool,look:Dictionary)->Texture2D:
 var key:String=str([left,look.base,look.spot,look.pattern])
 if cache.has(key):return cache[key]
 if cache.size()>128:cache.clear()
 var image:Image=(LEFT if left else RIGHT).get_image().duplicate()
 if image.is_compressed():image.decompress()
 var mask:Image=(MASK_LEFT if left else MASK_RIGHT).get_image()
 if mask.is_compressed():mask.decompress()
 var paint:Image=TownPaint215.texture(look).get_image()
 for y in image.get_height():
  for x in image.get_width():
   if mask.get_pixel(x,y).a<.5:continue
   var original:Color=image.get_pixel(x,y)
   var pigment:Color=paint.get_pixel(clampi(int(x*128./image.get_width()),0,127),clampi(int(y*128./image.get_height()),0,127))
   var shade:float=clampf(original.get_luminance()/0.82,.25,1.08)
   image.set_pixel(x,y,Color(pigment.r*shade,pigment.g*shade,pigment.b*shade,original.a))
 var texture:=ImageTexture.create_from_image(image);cache[key]=texture;return texture
static func post(node:CanvasItem,at:Vector2,left:bool,look:Dictionary):
 var texture:=painted(left,look)
 var size:Vector2=texture.get_size()*(146./307.)
 node.draw_texture_rect(texture,Rect2(at-Vector2(size.x*.5,98.),size),false)
