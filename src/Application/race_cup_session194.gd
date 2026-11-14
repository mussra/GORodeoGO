class_name RaceCupSession194
extends RefCounted
## Explicit opt-in objective sessions; claims use SaveData separately.
static var pending_result:Dictionary={}
static var pending_path:String=""
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
 if not pending_result.is_empty():return {"ok":false,"reason":"pending_result"}
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
 if not stored.ok:
  if RaceCup194.valid_result(result):pending_result=result.duplicate(true);pending_path=started_path
  last_notice="No se ha guardado este resultado. Vuelve a la copa y reintenta antes de cerrar el juego. El progreso anterior sigue protegido."
  return stored
 last_notice="Objetivo conseguido" if stored.decision.advanced else "Carrera terminada · el objetivo sigue pendiente"
 return stored

static func retry_pending()->Dictionary:
 if pending_result.is_empty():return {"ok":false,"reason":"nothing_pending"}
 if SaveData.trial_session_active or path()!=pending_path:return {"ok":false,"reason":"mode_changed"}
 var stored:=RaceCupStore194.record_result(pending_path,pending_result)
 if stored.ok:
  pending_result.clear();pending_path="";last_notice="Resultado recuperado y guardado"
 return stored
