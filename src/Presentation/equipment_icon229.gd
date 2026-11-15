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
 else:
  draw_line(Vector2(-29,34),Vector2(23,-25),Color("d9a55d"),7.,true);draw_line(Vector2(-31,36),Vector2(-12,14),Color("68432c"),12.,true)
  draw_arc(Vector2(20,-27),14.,-PI*.7,PI*.9,24,Color("ecd18e"),4.,true)
  if kind=="long":draw_arc(Vector2(26,-25),27.,-PI*.5,PI*.75,32,Color("f7dfac"),3.,true)
func draw_ellipse229(rect:Rect2,color:Color):
 var points:=PackedVector2Array()
 for i in 32:points.append(rect.get_center()+Vector2.from_angle(i*TAU/32)*rect.size*.5)
 draw_colored_polygon(points,color)
