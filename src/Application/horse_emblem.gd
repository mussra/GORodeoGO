class_name HorseEmblem
extends RefCounted
const COLORS=["74cbb2","db9a5b","6da8de","d18dbe","f2d987"]
const DEFAULT={"shape":0,"division":0,"left":0,"right":1,"color":0}
static var cache:Dictionary={}
## Rump wrap strength: fraction of the zone height the rear edge drops by.
static var warp_amount:=0.12
static func _remember(key:String,texture:Texture2D)->void:
 # Live typing makes new textures. Keep at most six full-HD portrait masks.
 var prefix:String="portrait" if key.begins_with("portrait") else "{"
 var matching:Array=[]
 for old in cache:
  if str(old).begins_with(prefix):matching.append(old)
 var limit:int=6 if prefix=="portrait" else 64
 while matching.size()>=limit:cache.erase(matching.pop_front())
 cache[key]=texture
static func valid(v:Variant)->bool:
 if not v is Dictionary:return false
 for key in DEFAULT:
  if typeof(v.get(key))!=TYPE_INT:return false
 if v.has("letters") and (not v.letters is String or v.letters!=sanitize_letters(v.letters)):return false
 if v.has("letters_font") and (not v.letters_font is int or v.letters_font not in range(2)):return false
 return v.shape in range(3) and v.division in range(3) and v.left in range(5) and v.right in range(5) and v.color in range(5)
static func sanitize_letters(value:String)->String:
 var out:String=""
 var upper:=value.to_upper()
 for pair in [["Á","A"],["É","E"],["Í","I"],["Ó","O"],["Ú","U"],["Ü","U"],["Ñ","N"]]:upper=upper.replace(pair[0],pair[1])
 for letter in upper:
  if letter>="A" and letter<="Z":out+=letter
 return out.left(3)
static func symbol(id:int,cx:float,cy:float,s:float)->String:
 match id:
  0:return '<circle cx="%s" cy="%s" r="%s"/><path d="M%s %s v%s M%s %s v%s M%s %s h%s M%s %s h%s"/>'%[cx,cy,s*.22,cx,cy-s*.62,s*.25,cx,cy+s*.37,s*.25,cx-s*.62,cy,s*.25,cx+s*.37,cy,s*.25]
  1:return '<path d="M%s %s l%s %s l%s %s l%s %s"/>'%[cx-s*.6,cy+s*.4,s*.4,-s*.85,s*.35,s*.55,s*.4,-s*.35]
  2:return '<path d="M%s %s l%s %s l%s %s l%s %s Z"/>'%[cx,cy-s*.65,s*.5,s*.65,-s*.5,s*.65,-s*.5,-s*.65]
  3:return '<path d="M%s %s v%s M%s %s h%s"/>'%[cx,cy-s*.65,s*1.3,cx-s*.6,cy,s*1.2]
  _:return '<path d="M%s %s q%s %s %s 0 q%s %s %s 0"/>'%[cx-s*.65,cy,s*.33,-s*.75,s*.65,s*.33,s*.75,s*.65]
## Symbol placement inside the shield, editable by the player (Ant, 7-nov-2026):
## bounded X/Y offset and scale, defaults keep the symbol clear of the initials.
const SYMBOL_DX_RANGE:=12
const SYMBOL_DY_MIN:=-12
const SYMBOL_DY_MAX:=14
const SYMBOL_SCALE_MIN:=0.5
const SYMBOL_SCALE_MAX:=1.0
static func symbol_dx(config:Dictionary)->int:return clampi(int(config.get("symbol_dx",0)),-SYMBOL_DX_RANGE,SYMBOL_DX_RANGE)
static func symbol_dy(config:Dictionary)->int:return clampi(int(config.get("symbol_dy",5)),SYMBOL_DY_MIN,SYMBOL_DY_MAX)
static func symbol_scale(config:Dictionary)->float:return clampf(float(config.get("symbol_scale",0.85)),SYMBOL_SCALE_MIN,SYMBOL_SCALE_MAX)
static func mask(config:Dictionary)->Texture2D:
 var key:=JSON.stringify(config)
 if cache.has(key):return cache[key]
 var dx:=symbol_dx(config);var dy:=symbol_dy(config);var sc:=symbol_scale(config)
 var shape:String=['<path d="M14 12 H86 L80 65 L50 88 L20 65 Z"/>','<circle cx="50" cy="49" r="37"/>','<path d="M16 12 H84 V72 L50 88 L16 72 Z"/>'][config.shape]
 var inside:String=symbol(config.left,50+dx,46+dy,23*sc)
 if config.division==1:inside='<path d="M50 13 V85"/>'+symbol(config.left,32+dx,44+dy,13*sc)+symbol(config.right,68+dx,44+dy,13*sc)
 if config.division==2:inside='<path d="M20 64 L80 22"/>'+symbol(config.left,35+dx,32+dy,12*sc)+symbol(config.right,64+dx,59+dy,12*sc)
 var svg:String='<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><g fill="none" stroke="white" stroke-width="5" stroke-linecap="round" stroke-linejoin="round">'+shape+inside+'</g></svg>'
 var image:=Image.new();image.load_svg_from_string(svg)
 stamp_letters(image,config)
 var texture:=ImageTexture.create_from_image(image);_remember(key,texture);return texture
## Up to 3 initials over the shield's upper band, pre-rendered white glyphs
## (stamp and the portrait shader color them through the ink's alpha).
static func stamp_letters(image:Image,config:Dictionary)->void:
 var letters:String=str(config.get("letters","")).to_upper().left(3)
 if letters.is_empty():return
 var font_dir:String=["graduate","cinzel"][int(config.get("letters_font",0))%2]
 var glyphs:Array=[]
 var total_w:=0
 for i in letters.length():
  var path:String="res://art/emblem/letters/%s/%s.png"%[font_dir,letters[i]]
  if not ResourceLoader.exists(path):continue
  var g:Image=load(path).get_image()
  if g.is_compressed():g.decompress()
  glyphs.append(g);total_w+=g.get_width()*13/g.get_height()+3
 if glyphs.is_empty():return
 total_w-=3
 var x:=50-total_w/2
 for g:Image in glyphs:
  var w:=g.get_width()*13/g.get_height()
  g.resize(w,13,Image.INTERPOLATE_LANCZOS)
  image.blit_rect(g,Rect2i(0,0,w,13),Vector2i(x,20))
  x+=w+3
## Wraps the emblem over the rump: columns fall away toward the rear (x=0) with a
## smooth quadratic, so the mark follows the thigh volume instead of floating flat.
static func warp_columns(ink:Image,amount:float)->Image:
 var w:=ink.get_width();var h:=ink.get_height()
 var out:=Image.create(w,h,false,Image.FORMAT_RGBA8);out.fill(Color.TRANSPARENT)
 var max_dy:=amount*h
 for x in w:
  var t:=float(x)/maxf(w-1,1.0)
  var dy:=int(round(max_dy*(1.0-t)*(1.0-t)))
  for y in h:
   if y+dy<h:out.set_pixel(x,y+dy,ink.get_pixel(x,y))
 return out
static func portrait_mask(config:Dictionary)->Texture2D:
 var key:="portrait"+JSON.stringify(config)
 if cache.has(key):return cache[key]
 var image:=Image.create(936,983,false,Image.FORMAT_RGBA8);image.fill(Color.TRANSPARENT)
 var area:Image=load("res://art/lineage_masks/portrait/adult.png").get_image()
 if area.is_compressed():area.decompress()
 var rect:Rect2i=area.get_used_rect()
 if rect.size.x>=2 and rect.size.y>=2:
  var ink:Image=mask(config).get_image();ink.resize(rect.size.x,rect.size.y,Image.INTERPOLATE_LANCZOS)
  ink=warp_columns(ink,warp_amount)
  image.blit_rect(ink,Rect2i(0,0,rect.size.x,rect.size.y),rect.position)
  var body:Image=load("res://art/portraits/adult_hd_mask.png").get_image()
  if body.is_compressed():body.decompress()
  for y in range(rect.position.y,rect.end.y):
   for x in range(rect.position.x,rect.end.x):
    var c:=image.get_pixel(x,y);c.a*=area.get_pixel(x,y).a
    # Hard rule (Ant): the emblem never sits on saddle, tack or rider.
    var bm:=body.get_pixel(x,y)
    if maxf(bm.r,bm.g)<.5:c.a=0.0
    image.set_pixel(x,y,c)
 var texture:=ImageTexture.create_from_image(image);_remember(key,texture);return texture
## Preserve the selected hue. An opposite rim supplies contrast against the coat.
static func ink(config:Dictionary,bg_luminance:float)->Array:
 var fg:Color=Color(COLORS[int(config.get("color",0))%COLORS.size()])
 var edge:=Color("201b1c") if bg_luminance>=.46 else Color("fff2d9")
 return [fg,edge]
static func stamp(image:Image,zone:Image,config:Dictionary,body:Image=null)->void:
 var rect:Rect2i=zone.get_used_rect()
 # Zone images are transparent outside the independently editable region.
 if rect.size.x<2 or rect.size.y<2:return
 var ink:Image=mask(config).get_image();ink.resize(rect.size.x,rect.size.y,Image.INTERPOLATE_LANCZOS)
 ink=warp_columns(ink,warp_amount)
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
   if body!=null:
    var bm:=body.get_pixelv(px)
    if maxf(bm.r,bm.g)<.5:continue
   var a:float=ink.get_pixel(x,y).a;var around:float=a
   for dy in range(-1,2):
    for dx in range(-1,2):around=maxf(around,ink.get_pixel(clampi(x+dx,0,ink.get_width()-1),clampi(y+dy,0,ink.get_height()-1)).a)
   var bg:Color=before.get_pixelv(px);var c:Color=bg.lerp(edge,around*.8).lerp(fg,a);c.a=bg.a;image.set_pixelv(px,c)
