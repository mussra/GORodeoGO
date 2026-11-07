class_name HorseEmblem
extends RefCounted
const COLORS=["74cbb2","db9a5b","6da8de","d18dbe","f2d987"]
const DEFAULT={"shape":0,"division":0,"left":0,"right":1,"color":0}
static var cache:Dictionary={}
static func valid(v:Variant)->bool:
 if not v is Dictionary:return false
 for key in DEFAULT:
  if typeof(v.get(key))!=TYPE_INT:return false
 return v.shape in range(3) and v.division in range(3) and v.left in range(5) and v.right in range(5) and v.color in range(5)
static func symbol(id:int,cx:float,cy:float,s:float)->String:
 match id:
  0:return '<circle cx="%s" cy="%s" r="%s"/><path d="M%s %s v%s M%s %s v%s M%s %s h%s M%s %s h%s"/>'%[cx,cy,s*.22,cx,cy-s*.62,s*.25,cx,cy+s*.37,s*.25,cx-s*.62,cy,s*.25,cx+s*.37,cy,s*.25]
  1:return '<path d="M%s %s l%s %s l%s %s l%s %s"/>'%[cx-s*.6,cy+s*.4,s*.4,-s*.85,s*.35,s*.55,s*.4,-s*.35]
  2:return '<path d="M%s %s l%s %s l%s %s l%s %s Z"/>'%[cx,cy-s*.65,s*.5,s*.65,-s*.5,s*.65,-s*.5,-s*.65]
  3:return '<path d="M%s %s v%s M%s %s h%s"/>'%[cx,cy-s*.65,s*1.3,cx-s*.6,cy,s*1.2]
  _:return '<path d="M%s %s q%s %s %s 0 q%s %s %s 0"/>'%[cx-s*.65,cy,s*.33,-s*.75,s*.65,s*.33,s*.75,s*.65]
static func mask(config:Dictionary)->Texture2D:
 var key:=JSON.stringify(config)
 if cache.has(key):return cache[key]
 var shape:String=['<path d="M14 12 H86 L80 65 L50 88 L20 65 Z"/>','<circle cx="50" cy="49" r="37"/>','<path d="M16 12 H84 V72 L50 88 L16 72 Z"/>'][config.shape]
 var inside:String=symbol(config.left,50,46,23)
 if config.division==1:inside='<path d="M50 13 V85"/>'+symbol(config.left,32,44,13)+symbol(config.right,68,44,13)
 if config.division==2:inside='<path d="M20 64 L80 22"/>'+symbol(config.left,35,32,12)+symbol(config.right,64,59,12)
 var svg:String='<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><g fill="none" stroke="white" stroke-width="5" stroke-linecap="round" stroke-linejoin="round">'+shape+inside+'</g></svg>'
 var image:=Image.new();image.load_svg_from_string(svg);var texture:=ImageTexture.create_from_image(image);cache[key]=texture;return texture
static func portrait_mask(config:Dictionary)->Texture2D:
 var key:="portrait"+JSON.stringify(config)
 if cache.has(key):return cache[key]
 var image:=Image.create(936,983,false,Image.FORMAT_RGBA8);image.fill(Color.TRANSPARENT)
 var ink:Image=mask(config).get_image();ink.resize(102,110,Image.INTERPOLATE_LANCZOS);image.blit_rect(ink,Rect2i(0,0,102,110),Vector2i(224,563))
 var area:Image=load("res://art/lineage_masks/portrait/adult.png").get_image()
 if area.is_compressed():area.decompress()
 for y in range(563,674):
  for x in range(224,327):
   var c:=image.get_pixel(x,y);c.a*=area.get_pixel(x,y).a;image.set_pixel(x,y,c)
 var texture:=ImageTexture.create_from_image(image);cache[key]=texture;return texture
## Ink for a chosen color over a background luminance: the picked color leads, and
## only when it would disappear against the coat it moves just enough to read (0.34
## luminance delta), keeping the opposite rim so edges survive pattern boundaries.
static func ink(config:Dictionary,bg_luminance:float)->Array:
 var fg:Color=Color(COLORS[int(config.get("color",0))%COLORS.size()])
 for i in 2:
  if absf(fg.get_luminance()-bg_luminance)>=.34:break
  var up:Color=fg.lightened(.55);var down:Color=fg.darkened(.55)
  fg=up if absf(up.get_luminance()-bg_luminance)>=absf(down.get_luminance()-bg_luminance) else down
 var edge:=Color("201b1c") if bg_luminance>=.46 else Color("fff2d9")
 return [fg,edge]
static func stamp(image:Image,zone:Image,config:Dictionary)->void:
 var rect:Rect2i=zone.get_used_rect()
 # Zone images are transparent outside the independently editable region.
 if rect.size.x<2 or rect.size.y<2:return
 var ink:Image=mask(config).get_image();ink.resize(rect.size.x,rect.size.y,Image.INTERPOLATE_LANCZOS)
 var luminance:float=0.;var count:int=0
 for y in range(rect.position.y,rect.end.y):
  for x in range(rect.position.x,rect.end.x):
   if zone.get_pixel(x,y).a<.5:continue
   var bg:=image.get_pixel(x,y);luminance+=bg.get_luminance();count+=1
 var pair:Array=ink(config,luminance/maxi(count,1));var fg:Color=pair[0];var edge:Color=pair[1]
 var before:Image=image.duplicate()
 for y in range(rect.size.y):
  for x in range(rect.size.x):
   var px:=rect.position+Vector2i(x,y)
   if zone.get_pixelv(px).a<.5 or before.get_pixelv(px).a<.5:continue
   var a:float=ink.get_pixel(x,y).a;var around:float=a
   for dy in range(-1,2):
    for dx in range(-1,2):around=maxf(around,ink.get_pixel(clampi(x+dx,0,ink.get_width()-1),clampi(y+dy,0,ink.get_height()-1)).a)
   var bg:Color=before.get_pixelv(px);var c:Color=bg.lerp(edge,around*.8).lerp(fg,a);c.a=bg.a;image.set_pixelv(px,c)
