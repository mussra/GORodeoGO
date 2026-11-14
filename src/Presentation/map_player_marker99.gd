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
 var _draw_position188:=position
 var _draw_scale188:=Vector2(1./maxf(scale.x,.001),1./maxf(scale.y,.001))
 position=Vector2.ZERO
 var aura:float=(sin(pulse*3.)+1.)*.5
 node.draw_circle(Vector2.ZERO,24.,Color(1.,.82,.24,.06+.19*aura))
 node.draw_arc(Vector2.ZERO,24.,0,TAU,56,Color(1.,.89,.44,.10+.40*aura),2.,true)
 var face:Vector2=velocity.normalized() if velocity.length()>=12. else Vector2.DOWN
 # The supplied arrow points up. Rotate the artwork, not just an overlay.
 # Keep caller position while rotating in screen units.
 node.draw_set_transform(_draw_position188,face.angle()+PI/2.,_draw_scale188)
 AntIcons188.draw_fit(node,2,Rect2(-12,-14,24,28))
 node.draw_set_transform(Vector2.ZERO)
