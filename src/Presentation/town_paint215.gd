class_name TownPaint215
extends RefCounted
static var textures:Dictionary={}
static var giraffe:Image
static func texture(look:Dictionary)->Texture2D:
 var key:String=str([look.base,look.spot,look.pattern])
 if textures.has(key):return textures[key]
 var base:=Color(look.base);var spot:=Color(look.spot)
 var image:=Image.create(128,128,false,Image.FORMAT_RGBA8);image.fill(base)
 if int(look.pattern)==10 and giraffe==null:
  giraffe=HorsePatternMap.GIRAFFE.get_image()
  if giraffe.is_compressed():giraffe.decompress()
  giraffe.resize(128,128,Image.INTERPOLATE_LANCZOS)
 if int(look.pattern)>0:
  for y in 128:
   for x in 128:
    var weight:float=0.
    if int(look.pattern)==10:weight=giraffe.get_pixel(x,y).r
    elif int(look.pattern)==6:
     for center in [Vector2(32,32),Vector2(96,96)]:
      if HorseAppearance.shape_point((Vector2(x,y)-center)/20.,6):weight=1.
    if int(look.pattern)==6 and weight==0.:
     for center in [Vector2(32,32),Vector2(96,96)]:
      if HorseAppearance.shape_point((Vector2(x,y)-center)/22.,6):image.set_pixel(x,y,Color("30283f"));break
    if weight>0.:image.set_pixel(x,y,base.lerp(spot,weight))
 var result:=ImageTexture.create_from_image(image);textures[key]=result;return result
static func wall(node:CanvasItem,box:Rect2,look:Dictionary,full_width:float=0.,center_x:float=INF):
 var points:=PackedVector2Array([box.position,Vector2(box.end.x,box.position.y),box.end,Vector2(box.position.x,box.end.y)])
 var uv:=PackedVector2Array()
 for point in points:uv.append(Vector2((point.x-((center_x if is_finite(center_x) else box.get_center().x)-(full_width if full_width>0. else box.size.x)*.5))/(full_width if full_width>0. else box.size.x),point.y/128.))
 node.draw_rect(box.grow(4),Color("514537"))
 node.draw_polygon(points,PackedColorArray([Color.WHITE]),uv,texture(look))
 # Fixed trim gives the base depth without recoloring the road or gate.
 node.draw_line(box.position+Vector2(5,0),Vector2(box.position.x+5,box.end.y),Color("f3dfb3"),10.)
 node.draw_line(Vector2(box.end.x-5,box.position.y),box.end-Vector2(5,0),Color("6e5b45"),10.)
 # Mortar courses and alternating joints give the painted base a masonry structure.
 var y:float=ceilf(box.position.y/48.)*48.
 while y<box.end.y:
  node.draw_line(Vector2(box.position.x+10,y),Vector2(box.end.x-10,y),Color("e0ceb0",.48),3.)
  var joint:float=box.position.x+box.size.x*(.35 if posmod(int(y/48.),2)==0 else .65)
  node.draw_line(Vector2(joint,y),Vector2(joint,minf(box.end.y,y+48.)),Color("e0ceb0",.36),2.)
  y+=48.
static func star(node:CanvasItem,center:Vector2,radius:float,color:Color):
 var points:=PackedVector2Array()
 for k in 10:
  var a:float=-PI*.5+k*PI/5.
  points.append(center+Vector2.from_angle(a)*radius*(1. if k%2==0 else .42))
 node.draw_colored_polygon(points,color)
static func icon(node:CanvasItem,rect:Rect2,look:Dictionary):
 # Existing towns have a road crossing an open separator, not an invented closed fortress.
 var at:Vector2=rect.position;var unit:Vector2=rect.size/Vector2(100,72)
 var base:=Color(look.base);var spot:=Color(look.spot)
 node.draw_style_box(RanchTheme.box(Color("b4bf8d"),Color("655a42"),4),rect)
 var road:=Rect2(at+Vector2(0,31)*unit,Vector2(100,10)*unit);node.draw_rect(road,Color("dbc18b"))
 for side in [-1,1]:
  var wall_box:=Rect2(at+Vector2(73,0 if side<0 else 47)*unit,Vector2(18,25)*unit)
  node.draw_rect(wall_box,base)
  if int(look.pattern)==6:
   star(node,wall_box.get_center(),minf(wall_box.size.x,wall_box.size.y)*.47,Color("30283f"))
   star(node,wall_box.get_center(),minf(wall_box.size.x,wall_box.size.y)*.38,spot)
  if int(look.pattern)==10:node.draw_texture_rect_region(texture(look),wall_box,Rect2(0,0,48,64))
  node.draw_line(wall_box.position,wall_box.position+Vector2(wall_box.size.x,0),Color("f4dfb5"),maxf(1.,unit.y*3.))
 for x in [22,48]:
  var p:Vector2=at+Vector2(x,13)*unit
  node.draw_rect(Rect2(p+Vector2(-6,0)*unit,Vector2(12,13)*unit),Color("f7dfac"))
  node.draw_colored_polygon(PackedVector2Array([p+Vector2(-9,0)*unit,p+Vector2(0,-8)*unit,p+Vector2(9,0)*unit]),Color("ad6650"))
 # Two gate posts flank the road. They never block its continuation.
 for y in [25,43]:node.draw_rect(Rect2(at+Vector2(70,y)*unit,Vector2(23,4)*unit),Color("7d5c3f"))
