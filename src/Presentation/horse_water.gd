class_name HorseWater
extends Node2D
## One registered shoreline footprint for any water kind. Split river rectangles
## around bridges/fords rather than registering one rectangle over a crossing.
var footprint:Rect2
var kind:String="water"
static func add(parent:Node2D,rect:Rect2,p_kind:String="water",solid:bool=true)->HorseWater:
 var water=HorseWater.new();water.footprint=rect;water.kind=p_kind;parent.add_child(water)
 if solid:
  var body=StaticBody2D.new();body.collision_layer=64;body.collision_mask=0;body.position=rect.get_center()
  var shape=CollisionShape2D.new();var box=RectangleShape2D.new();box.size=rect.size;shape.shape=box;body.add_child(shape);water.add_child(body)
 return water
func _ready()->void:add_to_group("horse_water")
func facing_from(actor:Node2D)->int:
 var p=to_local(actor.global_position)
 # Two supplied side poses: never invent an up/down pose or move the actor.
 for sign_x in [1,-1]:
  var mouth=p+Vector2(sign_x*58,-22)
  if footprint.grow(12).has_point(mouth) and not footprint.has_point(p):return sign_x
 return 0
