class_name RaceCupSession194
extends RefCounted
## Explicit opt-in only. Never uses the existing save or enables rewards.
static var active:bool=false
static var sequence:int=0
static var path_override:String=""
static var last_notice:String=""
static var started_path:String=""
static func path()->String:
 if not path_override.is_empty():return path_override
 return "user://cup-debug194.cfg" if SaveData.debug_mode else "user://cup-normal194.cfg"
static func load_state()->Dictionary:
 if SaveData.trial_session_active:return {"ok":false,"reason":"trial_session"}
 return RaceCupStore194.read_state(path())
static func begin()->Dictionary:
 var loaded:=load_state()
 if not loaded.ok:return loaded
 var goal:=RaceCup194.current(loaded.state)
 if goal.is_empty():return {"ok":false,"reason":"complete"}
 active=true;sequence=loaded.state.last_sequence+1;last_notice="";started_path=path()
 return {"ok":true,"goal":goal}
static func finish(result:Dictionary)->Dictionary:
 if not active:return {"ok":false,"reason":"not_active"}
 active=false
 if SaveData.trial_session_active or path()!=started_path:return {"ok":false,"reason":"mode_changed"}
 result=result.duplicate(true);result.sequence=sequence
 var stored:=RaceCupStore194.record_result(started_path,result)
 if not stored.ok:last_notice="No se ha guardado este resultado. El progreso anterior sigue protegido.";return stored
 last_notice="Objetivo conseguido" if stored.decision.advanced else "Carrera terminada · el objetivo sigue pendiente"
 return stored
