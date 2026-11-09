class_name WorldHerd
extends RefCounted
## Stable individuals derived from the existing herd genotype. A separate RNG
## keeps old decoration, base genetics and mission locations unchanged.
static func members(base:Dictionary,seed:int,cx:int,cy:int)->Array:
 if base.is_empty():return []
 var rng:=RandomNumberGenerator.new();rng.seed=hash("herd-members-%d-%d-%d"%[seed,cx,cy])
 var count:int=rng.randi_range(3,5);var out:Array=[]
 for i in count:
  var horse:Dictionary=base.duplicate(true)
  var angle:float=TAU*float(i)/count
  horse.pos=base.pos+Vector2(cos(angle),sin(angle))*rng.randf_range(70,125)
  horse.member_index=i;horse.member_count=count;horse.member_id=member_id(cx,cy,i)
  horse.appearance_scale=.96+float(i)*.02
  horse.traits.spots=contrasting_spots(int(horse.traits.coat),absi(hash("spots-%d-%d-%d"%[seed,cx,cy]))+i%2)
  # Keep coat, pattern and mane family fixed. Alternate small inherited traits.
  if i%2==1:
   horse.traits.eyes=(int(horse.traits.get("eyes",0))+1)%HorseCollection.EYES.size()
   horse.traits.legs=int(horse.traits.coat)
  out.append(horse)
 return out
static func member_id(cx:int,cy:int,index:int)->String:
 return WorldMap.herd_mission_id(cx,cy)+"#"+str(index)
static func all_captured(members_:Array,captured:Array)->bool:
 for member in members_:
  if not captured.has(member.member_id):return false
 return true

const GALLOP_SPEED:float=285.0
const PANIC_SPEED:float=350.0
const RECOVERY_SPEED:float=235.0
const PANIC_SECONDS:float=1.4
const CHASE_RECOVERY_AFTER:float=6.0
const FOLLOW_CATCHUP:float=55.0

static func escape_speed(panic:float,chase:float)->float:
 if panic>0.0:return PANIC_SPEED
 return RECOVERY_SPEED if chase>=CHASE_RECOVERY_AFTER else GALLOP_SPEED

## Keep family colors close, but reject near-matching coat/spot RGB colors.
static func contrasting_spots(coat:int,variant:int)->int:
 var base:=Color(HorseAppearance.COLORS[coat])
 var choices:Array[int]=[]
 for i in HorseAppearance.COLORS.size():
  var color:=Color(HorseAppearance.COLORS[i])
  if Vector3(base.r-color.r,base.g-color.g,base.b-color.b).length()>=.48:choices.append(i)
 return choices[posmod(variant,choices.size())]

const COHESION_RADIUS:float=280.0
const REGROUP_RADIUS:float=220.0

## Loose staggered slots behind a guide, never a single-file waypoint chain.
static func follow_velocity(position:Vector2,guide:Vector2,heading:Vector2,index:int,speed:float=230.0)->Vector2:
 var forward:Vector2=heading.normalized()
 var side:=Vector2(-forward.y,forward.x)
 var rank:int=maxi(0,index)
 var lateral:float=(-1.0 if rank%2==0 else 1.0)*(48.0+float(rank/2)*30.0)
 var behind:float=55.0+float(rank/2)*55.0
 var target:Vector2=guide-forward*behind+side*lateral
 var correction:Vector2=(target-position)*1.7
 return (forward*speed+correction.limit_length(115.0)).limit_length(speed+FOLLOW_CATCHUP)
