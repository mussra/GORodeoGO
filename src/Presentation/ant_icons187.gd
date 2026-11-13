class_name AntIcons187
extends RefCounted
## Ant's supplied sheet, cropped without labels. Dynamic overlays stay calculated.
static var cache:Dictionary={}
static func texture(cell:int)->Texture2D:
 if not cache.has(cell):cache[cell]=load("res://art/ui/ant_icons187/%02d.png"%cell)
 return cache[cell]
static func draw_fit(host:CanvasItem,cell:int,rect:Rect2,tint:Color=Color.WHITE)->void:
 var art:=texture(cell);var extent:=art.get_size();var k:=minf(rect.size.x/extent.x,rect.size.y/extent.y);var fitted:=extent*k
 host.draw_texture_rect(art,Rect2(rect.position+(rect.size-fitted)*.5,fitted),false,tint)
static func button(button:Button,cell:int,width:int=30)->void:
 button.icon=texture(cell);button.expand_icon=true;button.add_theme_constant_override("icon_max_width",width)
static func sized(cell:int,extent:Vector2i)->Texture2D:
 var key:=str(cell)+"_"+str(extent)
 if not cache.has(key):
  var image:=texture(cell).get_image()
  if image.is_compressed():image.decompress()
  image.resize(extent.x,extent.y,Image.INTERPOLATE_LANCZOS);cache[key]=ImageTexture.create_from_image(image)
 return cache[key]
