class_name ModeVictories240
extends RefCounted
## Facts only. Crown awards and unlock thresholds deliberately remain undecided.
const CROWN_WINS:int=1 # adjustable test award threshold
const MODES=["bulls","race","duel","joust","memory","cup"]
static func fresh()->Dictionary:
 return {"version":1,"last":0,"wins":{},"courses":{}}
static func valid(raw:Variant)->bool:
 if not raw is Dictionary or raw.get("version")!=1 or not raw.get("last") is int or raw.last<0:return false
 if not raw.get("wins") is Dictionary or not raw.get("courses") is Dictionary:return false
 for mode in raw.wins:
  if mode not in MODES or not raw.wins[mode] is int or raw.wins[mode]<0:return false
 for course in raw.courses:
  if course not in ["0","1","2","3"] or not raw.courses[course] is int or raw.courses[course]<1:return false
 return true
static func record(state:Dictionary,mode:String,sequence:int,course:int=-1)->bool:
 if not valid(state) or mode not in MODES or sequence<=state.last:return false
 if mode=="race" and (course<0 or course>3):return false
 state.last=sequence;state.wins[mode]=int(state.wins.get(mode,0))+1
 if mode=="race":state.courses[str(course)]=int(state.courses.get(str(course),0))+1
 return true
