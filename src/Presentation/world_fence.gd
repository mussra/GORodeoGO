class_name WorldFence
extends RefCounted
const Draw=preload("res://src/Presentation/world_draw_node.gd")
const RAILS=preload("res://art/world/cartoon/rails.png")
const POST=preload("res://art/world/cartoon/post.png")
## Continuous collider, local-depth visual slices. Open gaps are omitted by caller.
static func segment(world:Node2D,a:Vector2,b:Vector2,posts:bool=true,decorated:bool=false)->StaticBody2D:
 var body=StaticBody2D.new();body.collision_layer=HorseJump.FENCE_LAYER;body.collision_mask=0;body.position=(a+b)*.5;body.rotation=(b-a).angle();body.add_to_group("world_fence")
 var shape=CollisionShape2D.new();var rect=RectangleShape2D.new();rect.size=Vector2(a.distance_to(b)+1,8);shape.shape=rect;body.add_child(shape);world.add_child(body)
 var parts=maxi(1,int(ceil(a.distance_to(b)/8.0)))
 for i in parts:
  var start=a.lerp(b,float(i)/parts);var end=a.lerp(b,float(i+1)/parts);var visual=Draw.new();visual.position=(start+end)*.5
  var angle=(b-a).angle();var length=start.distance_to(end)+.6
  var region=Rect2(float(i)*RAILS.get_width()/parts,0,float(RAILS.get_width())/parts,RAILS.get_height())
  visual.draw_fn=func(n):
   if decorated:
    n.draw_set_transform(Vector2.ZERO,angle)
    if i%5==0:n.draw_line(Vector2(0,-31),Vector2(0,-11),Color("77502f"),5.,true)
    n.draw_line(Vector2(-length*.5,3).rotated(angle),Vector2(length*.5,3).rotated(angle),Color(0,0,0,.2),10.)
    for height in [-13.,-30.]:
     n.draw_set_transform(Vector2(0,height).rotated(angle),angle)
     n.draw_texture_rect_region(RAILS,Rect2(-length*.5,-5,length,10),region)
   else:
    n.draw_set_transform(Vector2(0,-16),angle)
    n.draw_texture_rect_region(RAILS,Rect2(-length*.5,-9,length,18),region)
  world.add_child(visual)
 if posts:
  var post_points:Array[Vector2]=[a]
  if decorated:post_points.append(a.lerp(b,.5));post_points.append(b)
  for point in post_points:
   var visual=Draw.new();visual.position=point+Vector2(0,4)
   visual.draw_fn=func(n):
    var height:float=44. if decorated else 34.
    var width:float=height*POST.get_width()/POST.get_height();n.draw_texture_rect(POST,Rect2(-width*.5,-height,width,height),false)
   world.add_child(visual)
 return body
static func crosses(actor:Node2D,target:Vector2)->bool:
 if not actor.is_inside_tree() or actor.position.distance_to(target)<.01:return false
 var query=PhysicsRayQueryParameters2D.create(actor.global_position,actor.global_position+(target-actor.position),HorseJump.FENCE_LAYER)
 return not actor.get_world_2d().direct_space_state.intersect_ray(query).is_empty()
## Old saves may lie inside a newly solid rail. Move only an overlapping fence spawn,
## choosing the nearest small clear offset. Never phase through a wall or teleport far.
static func clear_spawn(actor:CharacterBody2D)->bool:
 var shape=actor.get_node_or_null("CollisionShape2D")
 if shape==null:return true
 var q=PhysicsShapeQueryParameters2D.new();q.shape=shape.shape;q.transform=actor.global_transform;q.collision_mask=HorseJump.FENCE_LAYER;q.exclude=[actor.get_rid()]
 var space=actor.get_world_2d().direct_space_state
 if space.intersect_shape(q,1).is_empty():return true
 q.collision_mask=actor.collision_mask
 for distance in [12,24,36,48]:
  for i in 8:
   var offset=Vector2.RIGHT.rotated(i*TAU/8)*distance;q.transform=actor.global_transform;q.transform.origin+=offset
   if space.intersect_shape(q,1).is_empty():actor.global_position+=offset;return true
 return false
