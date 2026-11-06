class_name LassoRope
extends Node2D
var rider:Node2D
var start:Vector2
var landing:Vector2
var progress:float=0.0
var landing_radius:float=58.0
func _process(_delta:float) -> void:queue_redraw()
func _draw() -> void:
	if not is_instance_valid(rider):return
	# Keep the true ground landing target visible while the rope travels above it.
	draw_circle(landing,landing_radius,Color(1,.84,.5,.055))
	draw_arc(landing,landing_radius,0,TAU,48,Color(.95,.79,.5,.48),1.5,true)
	draw_circle(landing,3,Color(.95,.79,.5,.7))
	var origin:Vector2=rider.global_position+Vector2(8,-12)
	var tip:Vector2=start.lerp(landing,progress)+Vector2(0,-sin(progress*PI)*45)
	var edge:Vector2=loop_edge(tip,origin)
	var points:=PackedVector2Array()
	for i in range(17):
		var t:float=float(i)/16
		points.append(origin.lerp(edge,t)+Vector2(0,sin(t*PI)*14*progress))
	draw_polyline(points,Color("62452d"),5,true)
	draw_polyline(points,Color("e9c98e"),3,true)
	for i in range(1,points.size(),2):draw_line(points[i]-Vector2(1,1),points[i]+Vector2(1,1),Color("ad814d"),1,true)
	var loop:=PackedVector2Array()
	for i in range(33):
		var angle:float=i*TAU/32
		loop.append(tip+Vector2(cos(angle)*22,sin(angle)*11))
	draw_polyline(loop,Color("62452d"),5,true)
	draw_polyline(loop,Color("f4d69d"),2.8,true)

static func loop_edge(center:Vector2,origin:Vector2)->Vector2:
	var direction:Vector2=origin-center
	if direction.is_zero_approx():direction=Vector2.LEFT
	var divisor:float=sqrt(direction.x*direction.x/(22.0*22.0)+direction.y*direction.y/(11.0*11.0))
	return center+direction/divisor
