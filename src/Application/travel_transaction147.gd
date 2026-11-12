class_name TravelTransaction147
extends RefCounted
## Shared post-origin transaction. Caller durably saves the origin first.
## Callbacks own map-specific loading, collision validation and state commits.
## Never calls commit with an unsafe landing. Restore runs once on any failure.
var running:bool=false
var phase:String="idle"
func run(load_destination:Callable,validate_arrival:Callable,commit_destination:Callable,restore_origin:Callable)->Dictionary:
 if running:return {"ok":false,"reason":"busy","restored":false}
 running=true;phase="loading"
 var loaded:bool=await load_destination.call()
 var reason:String="load" if not loaded else ""
 var landing:Vector2=Vector2(INF,INF)
 if reason.is_empty():
  phase="validating";landing=await validate_arrival.call()
  if not landing.is_finite():reason="landing"
 if reason.is_empty():
  phase="committing"
  if not await commit_destination.call(landing):reason="save"
 var restored:bool=false
 if not reason.is_empty():phase="restoring";restored=await restore_origin.call()
 phase="done" if reason.is_empty() else "failed";running=false
 return {"ok":reason.is_empty(),"reason":reason,"restored":restored,"landing":landing}
