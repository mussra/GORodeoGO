class_name AnimalScare265
extends RefCounted
## Sound-only displacement: no health, damage, capture or reward mutation.
const BASIC:Dictionary={"radius":240.,"cooldown":5.,"seconds":1.1}
const IMPROVED:Dictionary={"radius":310.,"cooldown":4.,"seconds":1.4}
static func for_quality305(level:int)->Dictionary:
 return IMPROVED if level>=2 else BASIC
static func away(origin:Vector2,target:Vector2)->Vector2:
 var direction:=target-origin
 return direction.normalized() if direction.length_squared()>1. else Vector2.RIGHT
static func apply_to(animal:Node2D,origin:Vector2,settings:Dictionary)->bool:
 if not is_instance_valid(animal) or not animal.has_method("scare265") or animal.global_position.distance_to(origin)>float(settings.radius):return false
 return animal.scare265(origin,float(settings.seconds))
