class_name RaceScenery191
extends Node2D
## Static track decoration with existing ranch textures. Does not affect physics.
var course:RaceCourse190
const BUSH=preload("res://art/world/cartoon/bush1.png")
const TREE=preload("res://art/world/cartoon/tree.png")
const BARREL=preload("res://art/world/cartoon/barrel.png")
func _draw()->void:
 draw_rect(Rect2(-6000,-5000,12000,10000),Color("56754a"))
 draw_colored_polygon(course.points,Color("426443"))
 draw_polyline(course.points,Color("2c4534"),RaceCourse190.WIDTH+44.,true)
 draw_polyline(course.points,Color("80633c"),RaceCourse190.WIDTH+22.,true)
 draw_polyline(course.points,Color("d4b780"),RaceCourse190.WIDTH,true)
 for i in 192:
  var s:float=course.length*i/192.;var center:Vector2=course.at(s);var side:Vector2=course.tangent(s).orthogonal()
  for direction in [-1.,1.]:
   var p:Vector2=center+side*direction*181.
   draw_line(p,course.at(s+course.length/192.)+course.tangent(s+course.length/192.).orthogonal()*direction*181.,Color("f3deaa") if i%2==0 else Color("9c6e43"),9.,true)
  # Small ruts and gravel, deterministic and outside the rider's centre.
  var n:float=sin(i*27.31)
  var at:Vector2=center+side*n*135.
  draw_line(at,at+course.tangent(s)*14.,Color("b99a64"),2.,true)
 for i in 80:
  var s:float=course.length*(i+.3)/80.;var side:Vector2=course.tangent(s).orthogonal();var direction:float=-1. if i%2==0 else 1.
  var p:Vector2=course.at(s)+side*direction*(260.+absf(sin(i*13.))*90.)
  var texture:Texture2D=TREE if i%7==0 else BUSH
  var extent:=Vector2(90,110) if i%7==0 else Vector2(58,42)
  draw_circle(p+Vector2(9,4),extent.x*.3,Color(0,0,0,.1))
  AntIcons188.draw_texture_fit(self,texture,Rect2(p-Vector2(extent.x*.5,extent.y),extent))
 # Start/finish checkerboard aligned across the full track.
 var forward:Vector2=course.tangent(0.);var finish_side:Vector2=forward.orthogonal();var home:Vector2=course.at(0.)
 for row in 2:
  for col in 16:
   var p:Vector2=home+finish_side*(-190.+col*23.75)+forward*(row*14.-14.)
   draw_colored_polygon(PackedVector2Array([p,p+finish_side*23.75,p+finish_side*23.75+forward*14.,p+forward*14.]),Color("fff4d9") if (row+col)%2==0 else Color("443d32"))
 # Mark fence bypasses clearly without changing the actual WorldFence.
 for distance in course.fences:
  var center:Vector2=course.at(distance);var tangent:Vector2=course.tangent(distance);var side:Vector2=tangent.orthogonal()
  for sign in [-1.,1.]:
   var base:Vector2=center+side*(-175. if sign<0. else 40.)
   AntIcons188.draw_texture_fit(self,BARREL,Rect2(base+Vector2(-18,-32),Vector2(36,44)))
  var at:Vector2=center+side*132.-tangent*55.
  draw_polyline(PackedVector2Array([at-tangent*18.+side*13.,at+tangent*5.,at-tangent*18.-side*13.]),Color("f8edc9"),5.,true)
  draw_arc(center+side*132.,24.,0,TAU,24,Color("a5e9bc"),3.,true)
