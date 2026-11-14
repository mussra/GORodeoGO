extends Node
func _ready():run.call_deferred()
func run():
 SaveData.save_path="user://duel193sim-no-write.dat";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var duel=load("res://src/Presentation/duel193.tscn").instantiate();add_child(duel)
 duel.player.ai=true;duel.player.set_process_input(false);duel.player.orbit_sign=-1.
 var time:float=0.;var points:int=0
 while time<180. and not duel.finished:
  await get_tree().physics_frame;time+=get_physics_process_delta_time()
  if duel.result.visible:
   points=duel.scores[0]+duel.scores[1];print("DUEL193_SIM round=",duel.round_number," scores=",duel.scores," time=",time)
   if not duel.finished:duel._next_round()
 print("DUEL193_SUMMARY finished=",duel.finished," scores=",duel.scores," time=",time," saved=",FileAccess.file_exists(SaveData.save_path))
 var okay:bool=duel.finished and not FileAccess.file_exists(SaveData.save_path)
 duel.free();get_tree().quit(0 if okay else 1)
