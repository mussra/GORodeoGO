class_name MapPlayerMarker99
extends RefCounted
## Screen/UI units, independent of map area, cell size, zoom and discovery.
const RING_RADIUS:float=10.
const RING_WIDTH:float=2.
const BODY_RADIUS:float=7.
const FACE_RADIUS:float=5.
const DOT_RADIUS:float=2.
const ARROW_LENGTH:float=15.
const ARROW_HALF_WIDTH:float=4.
static func draw(node:CanvasItem,position:Vector2,velocity:Vector2,pulse:float):
 var scale:Vector2=node.get_viewport().get_stretch_transform().get_scale() * node.get_global_transform_with_canvas().get_scale().abs()
 node.draw_set_transform(position,0,Vector2(1./maxf(scale.x,.001),1./maxf(scale.y,.001)))
 position=Vector2.ZERO
 var color=Color("ffd23d");color.a=.8+.2*sin(pulse*4.)
 node.draw_arc(position,RING_RADIUS,0,TAU,40,color,RING_WIDTH,true)
 node.draw_circle(position,BODY_RADIUS,Color("201b1c"))
 node.draw_circle(position,FACE_RADIUS,Color("f8edce"))
 node.draw_circle(position,DOT_RADIUS,Color("d94f3d"))
 var face:Vector2=velocity.normalized() if velocity.length()>=12. else Vector2.DOWN
 var side:Vector2=face.orthogonal()*ARROW_HALF_WIDTH
 node.draw_colored_polygon(PackedVector2Array([position+face*ARROW_LENGTH,position+face*5.+side,position+face*5.-side]),Color("ffd23d"))
 node.draw_set_transform(Vector2.ZERO)
