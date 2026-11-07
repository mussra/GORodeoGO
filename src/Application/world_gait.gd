class_name WorldGait
extends RefCounted
## Frontera: paso / trote / galope from joystick intensity with hysteresis
## (Ant, 7-nov-2026: gait follows joystick strength, no dismounting).
## Hysteresis keeps the gait from flickering when the stick hovers at a boundary.

enum {PASO,TROTE,GALOPE}

const ENTER_TROTE:float=0.42
const EXIT_TROTE:float=0.30
const ENTER_GALOPE:float=0.82
const EXIT_GALOPE:float=0.66
## Fraction of the horse's top speed each gait allows.
const SPEED_FACTOR:Array[float]=[0.45,0.72,1.0]

static func gait_names()->Array[String]:
 return ["WORLD_GAIT_PASO","WORLD_GAIT_TROTE","WORLD_GAIT_GALOPE"]

## intensity: 0..1 joystick magnitude. Returns the (possibly unchanged) gait.
static func update(current:int,intensity:float)->int:
 match current:
  GALOPE:
   if intensity<EXIT_GALOPE:return TROTE
  TROTE:
   if intensity>=ENTER_GALOPE:return GALOPE
   if intensity<EXIT_TROTE:return PASO
  _:
   if intensity>=ENTER_GALOPE:return GALOPE
   if intensity>=ENTER_TROTE:return TROTE
 return current

static func speed_for(gait:int,max_speed:float)->float:
 return max_speed*SPEED_FACTOR[clampi(gait,0,2)]

## Playback pacing per gait so the same walk art reads as three distinct gaits:
## paso slow and grounded, trote brisk, galope stretched at the art's top rate.
static func pace_for(gait:int)->float:
 return [0.55,1.0,1.55][clampi(gait,0,2)]

## Body pose per gait (rider lean in radians, vertical bob amplitude in px).
static func pose_for(gait:int)->Vector2:
 return [Vector2(0.0,0.0),Vector2(0.05,1.5),Vector2(0.12,3.0)][clampi(gait,0,2)]
