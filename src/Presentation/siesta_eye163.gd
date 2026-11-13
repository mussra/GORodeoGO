class_name SiestaEye163
extends Control
var aperture:float=0.
func _draw():
 if size.x<=0. or size.y<=0. or aperture>=.99999:return
 var top:=PackedVector2Array([Vector2.ZERO,Vector2(size.x,0)])
 var bottom:=PackedVector2Array([Vector2(0,size.y),size])
 for i in range(64,-1,-1):
  var x:float=size.x*i/64.;var opening:float=size.y*.499*aperture*sin(PI*i/64.)
  top.append(Vector2(x,maxf(0.,size.y*.5-opening)));bottom.append(Vector2(x,minf(size.y,size.y*.5+opening)))
 draw_colored_polygon(top,Color("080d12"));draw_colored_polygon(bottom,Color("080d12"))
