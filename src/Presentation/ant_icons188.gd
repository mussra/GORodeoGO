class_name AntIcons188
extends RefCounted
## Replacement sheet supplied by Ant. Labels removed, source retained.
static var cache:Dictionary={}
static func texture(cell:int)->Texture2D:
 if not cache.has(cell):cache[cell]=load("res://art/ui/ant_icons188/%02d.png"%cell)
 return cache[cell]
static func draw_fit(host:CanvasItem,cell:int,rect:Rect2)->void:
 draw_texture_fit(host,texture(cell),rect)
static func draw_texture_fit(host:CanvasItem,art:Texture2D,rect:Rect2)->void:
 var extent:=art.get_size();var k:=minf(rect.size.x/extent.x,rect.size.y/extent.y);var fitted:=extent*k
 host.draw_texture_rect(art,Rect2(rect.position+(rect.size-fitted)*.5,fitted),false)
static func flower(tint:Color)->Texture2D:
 var key:="flower_"+tint.to_html()
 if not cache.has(key):
  var image:=texture(5).get_image()
  if image.is_compressed():image.decompress()
  for y in image.get_height():
   for x in image.get_width():
    var c:=image.get_pixel(x,y)
    # Tint petals only. Preserve cream centre, brown outline and source alpha.
    if c.a>0. and c.g>c.r*1.25 and c.b>c.r*1.25:
     image.set_pixel(x,y,Color.from_hsv(tint.h,tint.s,c.v*tint.v,c.a))
  cache[key]=ImageTexture.create_from_image(image)
 return cache[key]
static func joystick_ring(pressed:bool)->StyleBoxTexture:
 var style:=StyleBoxTexture.new();style.texture=texture(8);style.modulate_color=Color(1,1,1,.95 if pressed else .65)
 return style
