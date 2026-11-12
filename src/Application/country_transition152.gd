class_name CountryTransition152
extends RefCounted
## State-only coordinator. A caller supplies source/destination scene checks.
## Entry and exit both use the same load -> validate -> durable commit protocol.
var transaction:TravelTransaction147
var initial_state:Dictionary={}
var prior_state:Dictionary={}
var origin:Vector2
var busy:bool=false
func enter152(session:CountrySession152,source_position:Vector2,load_scene:Callable,validate_scene:Callable,restore_source:Callable)->Dictionary:
 if busy:return {"ok":false,"reason":"busy","restored":false}
 busy=true;var result:Dictionary=await _enter152(session,source_position,load_scene,validate_scene,restore_source);busy=false;return result
func _enter152(session:CountrySession152,source_position:Vector2,load_scene:Callable,validate_scene:Callable,restore_source:Callable)->Dictionary:
 if not source_position.is_finite() or SaveData.trial_session_active:return {"ok":false,"reason":"origin","restored":true}
 origin=source_position;prior_state=SaveData.country_ledger146.duplicate(true)
 if prior_state.is_empty():initial_state=CountryLedger146.enter(CountryLedger146.fresh(SaveData.world_seed,SaveData.world_generator_version),origin,session.seed)
 elif prior_state.get("active","")==CountryRoute146.ID:initial_state=CountryLedger146.upgrade(prior_state)
 else:initial_state=CountryLedger146.enter(prior_state,origin,session.seed)
 if initial_state.is_empty():return {"ok":false,"reason":"ledger","restored":true}
 if prior_state.get("active", "frontier")=="frontier" and not SaveData.save_world_state(origin):return {"ok":false,"reason":"origin_save","restored":true}
 session.session_state=initial_state.duplicate(true)
 transaction=TravelTransaction147.new()
 return await transaction.run(load_scene,validate_scene,func(pos:Vector2)->bool:
  var next:=CountryLedger146.record_exploration(session.ledger,pos,session.visited_cells)
  if next.is_empty() or not SaveData.store_country_ledger146(next):return false
  session.ledger=next;session.player.position=pos;session.camera.reset_smoothing();return session.activate152(),restore_source)
func exit152(session:CountrySession152,validate_source:Callable,restore_country:Callable)->Dictionary:
 if busy:return {"ok":false,"reason":"busy","restored":false}
 busy=true;var result:Dictionary=await _exit152(session,validate_source,restore_country);busy=false;return result
func _exit152(session:CountrySession152,validate_source:Callable,restore_country:Callable)->Dictionary:
 var snapshot:=session.snapshot152()
 if snapshot.is_empty():return {"ok":false,"reason":"ledger","restored":true}
 var plan:=CountryLedger146.leave(snapshot,session.player.position)
 if plan.is_empty():return {"ok":false,"reason":"ledger","restored":true}
 transaction=TravelTransaction147.new()
 return await transaction.run(func():return true,validate_source,func(pos:Vector2)->bool:return SaveData.commit_country_exit152(plan.state,pos),restore_country)
