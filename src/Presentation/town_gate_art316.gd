class_name TownGateArt316
extends RefCounted
const LEFT=preload('res://art/town316/leaf-left.png')
const RIGHT=preload('res://art/town316/leaf-right.png')
const HEIGHT:float=90.
const HINGE_OFFSET:float=18.
static func rect(at:Vector2,left:bool)->Rect2:
 var size:Vector2=LEFT.get_size()*(HEIGHT/LEFT.get_height())
 return Rect2(at+Vector2(-HINGE_OFFSET-size.x if left else HINGE_OFFSET,-44.),size)
static func leaf(node:CanvasItem,at:Vector2,left:bool):
 node.draw_texture_rect(LEFT if left else RIGHT,rect(at,left),false)
