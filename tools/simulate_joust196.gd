extends Node
func _ready():run.call_deferred()
func run():
 SaveData.save_path="user://joust196sim-no-write.cfg";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var joust=load("res://src/Presentation/joust196.tscn").instantiate();add_child(joust)
 joust.player.ai=true;joust.player.set_process_input(false)
 var time:float=0.
 while time<180. and not joust.finished:
  await get_tree().physics_frame;time+=get_physics_process_delta_time()
  if joust.result.visible:
   print("JOUST196_PASS pass=",joust.pass_number," scores=",joust.scores," time=",time)
   if not joust.finished:joust._next_round()
 print("JOUST196_SUMMARY finished=",joust.finished," scores=",joust.scores," passes=",joust.pass_number," time=",time," saved=",FileAccess.file_exists(SaveData.save_path))
 var okay:bool=joust.finished and not FileAccess.file_exists(SaveData.save_path)
 joust.free();get_tree().quit(0 if okay else 1)
