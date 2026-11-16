extends "res://src/Presentation/frontier_world.gd"
var samples242:Dictionary={}
func _record242(key:String,t:int):
 if not samples242.has(key):samples242[key]=[]
 samples242[key].append(Time.get_ticks_usec()-t)
func _process(delta:float):
 var t=Time.get_ticks_usec();super._process(delta);_record242('world_process',t)
func _update_chunks():
 var t=Time.get_ticks_usec();super._update_chunks();_record242('chunks',t)
func _tick_npcs():
 var t=Time.get_ticks_usec();super._tick_npcs();_record242('npcs',t)
func _refresh_quest_hud():
 var t=Time.get_ticks_usec();super._refresh_quest_hud();_record242('quest_hud',t)
