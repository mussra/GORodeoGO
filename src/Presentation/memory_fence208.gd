class_name MemoryFence208
extends Node2D
## One geometry for obstacle collision, scoring and minimap orientation.
const VERTICAL=[false,true,false,true]
var index:int=0
static func half_axis(index_value:int)->Vector2:
 return Vector2(0,75) if VERTICAL[index_value] else Vector2(75,0)
static func normal(index_value:int)->Vector2:
 return half_axis(index_value).orthogonal().normalized()
func _ready():
 var body:=StaticBody2D.new();body.collision_layer=HorseJump.FENCE_LAYER;body.collision_mask=0;body.add_to_group("world_fence");add_child(body)
 var shape:=CollisionShape2D.new();var rect:=RectangleShape2D.new();rect.size=Vector2(8,151) if VERTICAL[index] else Vector2(151,8);shape.shape=rect;body.add_child(shape)
 var sprite:=Sprite2D.new();sprite.name="FenceArt";sprite.texture=load("res://art/memory208/%d-%s.png"%[index+1,"vertical" if VERTICAL[index] else "horizontal"])
 sprite.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
 var fit:=Vector2(66,180) if VERTICAL[index] else Vector2(190,108)
 sprite.scale=Vector2.ONE*minf(fit.x/sprite.texture.get_width(),fit.y/sprite.texture.get_height())
 sprite.position=Vector2(0,-10) if VERTICAL[index] else Vector2(0,-28)
 add_child(sprite)
