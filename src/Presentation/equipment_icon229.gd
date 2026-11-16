class_name EquipmentIcon229
extends Control
var kind:String="whip"
func _ready():mouse_filter=Control.MOUSE_FILTER_IGNORE
func _draw():
 var center:Vector2=size*.5;var k:float=minf(size.x,size.y)/100.
 draw_set_transform(center,0,Vector2.ONE*k)
 if kind=="horse":
  var record:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
  AntIcons188.draw_texture_fit(self,PixelLabTrial.pose_texture("horse","side",0,record.traits,record),Rect2(-49,-49,98,98))
 elif kind=="adorn":AntIcons187.draw_fit(self,38,Rect2(-45,-45,90,90))
 elif kind=="hat":
  draw_ellipse229(Rect2(-44,12,88,22),Color("a76a35"));draw_style_box(RanchTheme.box(Color("c68d4d"),Color("4d3626"),12),Rect2(-24,-29,48,55));draw_line(Vector2(-25,8),Vector2(25,8),Color("593e2d"),10.)
 elif kind=="finish":
  TownPaint215.star(self,Vector2(-13,-6),32,Color("ffd77b"));TownPaint215.star(self,Vector2(29,26),16,Color("84dbe0"));TownPaint215.star(self,Vector2(28,-31),11,Color("f4f5dc"))
 elif kind=="back":draw_polyline(PackedVector2Array([Vector2(18,-27),Vector2(-17,0),Vector2(18,27)]),Color("f7d58a"),11.,true)
 elif kind=="buy":
  draw_circle(Vector2.ZERO,32,Color("ba8330"));draw_circle(Vector2.ZERO,25,Color("f5c858"));draw_line(Vector2(-12,0),Vector2(12,0),Color("81501e"),5.);draw_line(Vector2(0,-12),Vector2(0,12),Color("81501e"),5.)
 elif kind=="equip":draw_polyline(PackedVector2Array([Vector2(-29,0),Vector2(-7,22),Vector2(32,-25)]),Color("8ddca8"),12.,true)
 elif kind=="saddle":
  draw_arc(Vector2(0,6),30.,PI,TAU,28,Color("8a5a33"),14.,true)
  draw_line(Vector2(-38,8),Vector2(38,8),Color("593e2d"),8.)
  draw_line(Vector2(-16,14),Vector2(-22,36),Color("8a5a33"),7.,true)
  draw_line(Vector2(16,14),Vector2(22,36),Color("8a5a33"),7.,true)
 elif kind=="reins":
  draw_arc(Vector2(-14,-4),24.,PI*.1,PI*1.1,24,Color("c68d4d"),5.,true)
  draw_arc(Vector2(16,2),24.,PI*.2,PI*1.05,24,Color("a76a35"),5.,true)
  draw_line(Vector2(-30,18),Vector2(30,26),Color("593e2d"),4.)
 elif kind=="stirrups":
  draw_line(Vector2(-20,-34),Vector2(-20,-8),Color("593e2d"),6.)
  draw_line(Vector2(20,-34),Vector2(20,-8),Color("593e2d"),6.)
  draw_arc(Vector2(-20,2),16.,0.,PI,20,Color("b8bfc6"),6.,true)
  draw_arc(Vector2(20,2),16.,0.,PI,20,Color("b8bfc6"),6.,true)
  draw_line(Vector2(-36,2),Vector2(-4,2),Color("b8bfc6"),6.)
  draw_line(Vector2(4,2),Vector2(36,2),Color("b8bfc6"),6.)
 elif kind=="shoes":
  draw_arc(Vector2(0,0),28.,PI*.85,PI*2.15,28,Color("9aa4ab"),9.,true)
  for a in [PI*.95,PI*1.35,PI*1.75,PI*2.05]:
   draw_circle(Vector2(0,0)+Vector2.from_angle(a)*28.,3.5,Color("5c666d"))
 elif kind=="spurs":
  draw_line(Vector2(-30,14),Vector2(14,14),Color("593e2d"),7.)
  TownPaint215.star(self,Vector2(24,14),15,Color("e8c96a"))
  TownPaint215.star(self,Vector2(-26,-16),9,Color("b8bfc6"))
 elif kind=="blanket":
  draw_colored_polygon(PackedVector2Array([Vector2(-34,-14),Vector2(34,-14),Vector2(38,18),Vector2(-38,18)]),Color("7a3b2e"))
  draw_colored_polygon(PackedVector2Array([Vector2(-38,18),Vector2(38,18),Vector2(38,25),Vector2(-38,25)]),Color("e8c96a"))
  draw_line(Vector2(-18,-14),Vector2(-18,18),Color("e8c96a"),3.)
  draw_line(Vector2(18,-14),Vector2(18,18),Color("e8c96a"),3.)
 elif kind=="hat_gala":
  draw_ellipse229(Rect2(-44,12,88,22),Color("2e2a26"));draw_style_box(RanchTheme.box(Color("4a423b"),Color("211d19"),12),Rect2(-24,-29,48,55));draw_line(Vector2(-25,8),Vector2(25,8),Color("e8c96a"),8.)
 else:
  draw_line(Vector2(-29,34),Vector2(23,-25),Color("d9a55d"),7.,true);draw_line(Vector2(-31,36),Vector2(-12,14),Color("68432c"),12.,true)
  draw_arc(Vector2(20,-27),14.,-PI*.7,PI*.9,24,Color("ecd18e"),4.,true)
  if kind=="long":draw_arc(Vector2(26,-25),27.,-PI*.5,PI*.75,32,Color("f7dfac"),3.,true)
func draw_ellipse229(rect:Rect2,color:Color):
 var points:=PackedVector2Array()
 for i in 32:points.append(rect.get_center()+Vector2.from_angle(i*TAU/32)*rect.size*.5)
 draw_colored_polygon(points,color)
