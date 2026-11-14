extends Node
## End-to-end simulation without screenshots or save writes. All four race fairly.
func _ready():run.call_deferred()
func run():
 SaveData.save_path="user://race191-never-written.dat";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var failures:int=0;var runs:int=0
 for jumper in ([true] if OS.get_cmdline_user_args().size()>1 else [false,true]):
  SaveData.horse_collection.find(SaveData.horse_collection.selected).can_jump=jumper
  for course in RaceCourse190.TITLES.size():
   if not OS.get_cmdline_user_args().is_empty() and course!=int(OS.get_cmdline_user_args()[0]):continue
   for round_index in 1:
    RaceCourse190.selected=course
    var race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race);race.selector.hide();race.countdown=0.;race.running=true;race._announced=true
    race.player.ai=true;race.player.set_process_input(false)
    for rider in race.riders:rider.attack_think+=round_index*.2;rider.lane=clampf(rider.lane+round_index*12.,-120.,120.)
    Engine.time_scale=1.
    var max_seconds:float=0.
    while max_seconds<110.:
     await get_tree().physics_frame;max_seconds+=get_physics_process_delta_time()
     if race.riders.all(func(r):return r.finish_time>=0.):break
    Engine.time_scale=1.
    var finished:int=0;var gates:Array=[]
    for rider in race.riders:
     gates.append(rider.next_gate)
     if rider.finish_time>=0.:finished+=1
    var okay:bool=finished==4 and not FileAccess.file_exists(SaveData.save_path)
    if not okay:
     failures+=1
     for rider in race.riders:print("STUCK191 ",rider.racer_name," gate=",rider.next_gate," pos=",rider.position," vel=",rider.velocity," s=",race.course.project(rider.position).s)
    runs+=1
    print("SIM191 course=",course," jumper=",jumper," round=",round_index," finished=",finished," gates=",gates," time=",max_seconds," hits=",race.hit_count," throws=",race.throws_count," okay=",okay)
    race.free();await get_tree().process_frame
 RaceCourse190.selected=0;Engine.time_scale=1.
 print("SIM191_SUMMARY runs=",runs," failed=",failures)
 get_tree().quit(1 if failures else 0)
