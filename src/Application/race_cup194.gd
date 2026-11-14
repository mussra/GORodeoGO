class_name RaceCup194
extends RefCounted
## Preparation-only objective ledger. No integration, saves, money, horse or story
## effects. A caller must explicitly opt in after the proposal has been reviewed.
const RULE:int=1
const CHALLENGES:Array[Dictionary]=[
 {"id":"learn_oval","chapter":1,"title":"Primera vuelta","mode":"race","course":0,"rank":4},
 {"id":"learn_valley","chapter":1,"title":"Lee las curvas","mode":"race","course":1,"rank":4},
 {"id":"learn_serpent","chapter":1,"title":"Sigue el recorrido","mode":"race","course":2,"rank":4},
 {"id":"learn_crossing","chapter":1,"title":"Mira a ambos lados","mode":"race","course":3,"rank":4},
 {"id":"podium_oval","chapter":2,"title":"Podio en el óvalo","mode":"race","course":0,"rank":3},
 {"id":"podium_valley","chapter":2,"title":"Podio en el valle","mode":"race","course":1,"rank":3},
 {"id":"podium_serpent","chapter":2,"title":"Podio en serpiente","mode":"race","course":2,"rank":3},
 {"id":"podium_crossing","chapter":2,"title":"Podio entre cruces","mode":"race","course":3,"rank":3},
 {"id":"lasso_podium","chapter":3,"title":"Apunta y compite","mode":"race","course":-1,"rank":3,"landed":1},
 {"id":"dodge_podium","chapter":3,"title":"Esquiva y sigue","mode":"race","course":-1,"rank":3,"dodges":1},
 {"id":"duel_win","chapter":3,"title":"Primer duelo","mode":"duel"},
 {"id":"clean_podium","chapter":3,"title":"Concentración","mode":"race","course":-1,"rank":3,"max_hits":0},
 {"id":"win_oval","chapter":4,"title":"Victoria en el óvalo","mode":"race","course":0,"rank":1},
 {"id":"win_valley","chapter":4,"title":"Victoria en el valle","mode":"race","course":1,"rank":1},
 {"id":"win_serpent","chapter":4,"title":"Victoria en serpiente","mode":"race","course":2,"rank":1},
 {"id":"win_crossing","chapter":4,"title":"Victoria en el cruce","mode":"race","course":3,"rank":1}
]
static func fresh()->Dictionary:return {"rule":RULE,"completed":[],"last_sequence":0}
static func valid(state:Variant)->bool:
 if not state is Dictionary or state.get("rule")!=RULE:return false
 if not state.get("last_sequence") is int or state.last_sequence<0:return false
 var completed:Variant=state.get("completed")
 if not completed is Array or completed.size()>CHALLENGES.size() or state.last_sequence<completed.size():return false
 for i in completed.size():
  if completed[i]!=CHALLENGES[i].id:return false
 return true
static func current(state:Dictionary)->Dictionary:
 if not valid(state) or state.completed.size()==CHALLENGES.size():return {}
 return CHALLENGES[state.completed.size()].duplicate(true)
static func valid_result(result:Dictionary)->bool:
 if not result.get("sequence") is int or result.sequence<1:return false
 if not result.get("mode") in ["race","duel"] or not result.get("finished") is bool or not result.finished:return false
 if result.mode=="duel":
  var a:Variant=result.get("player_wins");var b:Variant=result.get("rival_wins")
  return a is int and b is int and a>=0 and b>=0 and a<=2 and b<=2 and ((a==2 and b<2) or (b==2 and a<2))
 if not result.get("course") is int or result.course<0 or result.course>3:return false
 if not result.get("rank") is int or result.rank<1 or result.rank>4:return false
 if result.get("gates",0)!=16:return false
 for key in ["landed","dodges","hits"]:
  if not result.get(key) is int or result[key]<0:return false
 return true
static func matches(goal:Dictionary,result:Dictionary)->bool:
 if not valid_result(result) or goal.get("mode")!=result.mode:return false
 if result.mode=="duel":return result.player_wins==2
 return (goal.course<0 or goal.course==result.course) and result.rank<=goal.rank and result.landed>=goal.get("landed",0) and result.dodges>=goal.get("dodges",0) and result.hits<=goal.get("max_hits",2147483647)
static func record(state:Dictionary,result:Dictionary)->Dictionary:
 if not valid(state):return {"accepted":false,"reason":"invalid_state"}
 if not valid_result(result):return {"accepted":false,"reason":"invalid_result"}
 if result.sequence<=state.last_sequence:return {"accepted":false,"reason":"duplicate_or_old"}
 state.last_sequence=result.sequence
 var goal:Dictionary=current(state)
 if goal.is_empty():return {"accepted":true,"advanced":false,"complete":true}
 var advanced:bool=matches(goal,result)
 if advanced:state.completed.append(goal.id)
 return {"accepted":true,"advanced":advanced,"complete":state.completed.size()==CHALLENGES.size(),"goal":goal.id}
