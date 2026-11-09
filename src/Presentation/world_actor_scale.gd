class_name WorldActorScale
extends RefCounted
## Frontera-only visual sizing. Never scale physics hosts, range or map positions.
const HORSE:float=1.20
static func rider(sprite:AnimatedSprite2D)->void:
 sprite.scale=Vector2.ONE*HORSE
 # Idle art feet at centered y44. Offset before scale keeps that anchor unchanged.
 sprite.offset.y=44.0/HORSE-44.0
