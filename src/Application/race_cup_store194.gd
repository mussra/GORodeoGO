class_name RaceCupStore194
extends RefCounted
## Dormant until a reviewed opt-in calls it. Separate from every existing save.
## Never repairs or replaces unreadable/unknown-version data with defaults.
static func read_state(path:String)->Dictionary:
 if not FileAccess.file_exists(path):return {"ok":true,"new":true,"state":RaceCup194.fresh()}
 var config:=ConfigFile.new()
 if config.load(path)!=OK:return {"ok":false,"reason":"unreadable"}
 if not config.has_section_key("cup","state"):return {"ok":false,"reason":"missing_state"}
 var raw:Variant=config.get_value("cup","state")
 if not RaceCup194.valid(raw):return {"ok":false,"reason":"invalid_or_future_version"}
 return {"ok":true,"new":false,"state":raw.duplicate(true)}
static func write_state(path:String,state:Dictionary)->Dictionary:
 if not RaceCup194.valid(state):return {"ok":false,"reason":"invalid_state"}
 var current:=read_state(path)
 if not current.ok:return current
 if not current.new and current.state.last_sequence>state.last_sequence:return {"ok":false,"reason":"stale_write"}
 if not current.new and current.state.last_sequence==state.last_sequence and current.state!=state:return {"ok":false,"reason":"conflicting_write"}
 if not current.new:
  var prefix:Array=current.state.completed
  if state.completed.size()<prefix.size():return {"ok":false,"reason":"progress_regression"}
  for i in prefix.size():
   if prefix[i]!=state.completed[i]:return {"ok":false,"reason":"progress_regression"}
 var config:=ConfigFile.new();config.set_value("cup","state",state)
 var temp:String=path+".tmp"
 var error:Error=config.save(temp)
 if error!=OK:return {"ok":false,"reason":"write_failed","error":error}
 var verified:=read_state(temp)
 if not verified.ok or verified.state!=state:
  DirAccess.remove_absolute(temp)
  return {"ok":false,"reason":"verify_failed"}
 error=DirAccess.rename_absolute(temp,path)
 if error!=OK:return {"ok":false,"reason":"rename_failed","error":error}
 return {"ok":true}
static func record_result(path:String,result:Dictionary)->Dictionary:
 var loaded:=read_state(path)
 if not loaded.ok:return loaded
 var state:Dictionary=loaded.state
 var decision:=RaceCup194.record(state,result)
 if not decision.accepted:return {"ok":false,"reason":decision.reason}
 var stored:=write_state(path,state)
 if not stored.ok:return stored
 return {"ok":true,"decision":decision,"state":state}
