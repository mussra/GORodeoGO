extends Node
func _ready():run.call_deferred()
func sample()->Dictionary:
 var times:Array[float]=[]
 for i in 120:
  var before:=Time.get_ticks_usec();await get_tree().process_frame;times.append((Time.get_ticks_usec()-before)/1000.)
 times.sort();var total:float=0.
 for value in times:total+=value
 return {"mean_ms":total/times.size(),"p95_ms":times[114],"nodes":Performance.get_monitor(Performance.OBJECT_NODE_COUNT),"memory_mib":Performance.get_monitor(Performance.MEMORY_STATIC)/1048576.,"draw_calls":Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)}
func run():
 get_tree().root.size=Vector2i(1280,720);GameState.sound_enabled=false;SaveData.horse_collection.seed_trial()
 var results:Dictionary={};await get_tree().create_timer(.3).timeout;results.baseline=await sample()
 var view:=HorseVictory251.new();view.reward=VictoryGrowth251.apply(SaveData.horse_collection,"original","race");add_child(view)
 results.animation=await sample();await get_tree().create_timer(.3).timeout;results.settled=await sample()
 view.queue_free();await get_tree().process_frame;results.closed=await sample()
 var file:=FileAccess.open("/downloads/perf251.json",FileAccess.WRITE);file.store_string(JSON.stringify(results,"  "));file.close();print("PERF251 ",JSON.stringify(results));get_tree().quit()
