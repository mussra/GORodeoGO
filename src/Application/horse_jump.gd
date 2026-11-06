class_name HorseJump
extends RefCounted
const FENCE_LAYER:int=32
const DURATION:float=.68
const DISTANCE:float=180.0
static func capable(h:Dictionary)->bool:
 return bool(h.get("can_jump",false))
static func arc(t:float)->float:return sin(PI*clampf(t,0,1))*43.0
