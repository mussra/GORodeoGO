extends Node
func _ready():run.call_deferred()
func measure(player,label_):
 player.set_physics_process(false);player.velocity=Vector2.ZERO;get_tree().paused=false;Engine.time_scale=1.
 var lasso=player.lasso
 lasso.prey_provider=func():return []
 lasso.can_capture=func():return true
 lasso.throw_guard=func():return true
 var times:Array=[]
 for i in 4:
  lasso.set_active_capture_count(0);lasso._charge_distance=180.;lasso.aim_direction=Vector2.RIGHT
  var stamp:Array=[Time.get_ticks_usec(),-1]
  var on_land=func(_point,_prey):stamp[1]=Time.get_ticks_usec()
  lasso.landing_resolved.connect(on_land,CONNECT_ONE_SHOT)
  lasso._release_throw()
  await get_tree().create_timer(lasso.lasso_travel_time+.15).timeout
  times.append((stamp[1]-stamp[0])/1000000. if stamp[1]>0 else -1.)
  if lasso.landing_resolved.is_connected(on_land):lasso.landing_resolved.disconnect(on_land)
  await get_tree().process_frame
 print("LASSO109 ",label_," configured=",lasso.lasso_travel_time," measured=",times)

func run():
 SaveData.save_path="user://measurement109-only.dat";SaveData.trial_session_active=true;SaveData.dual_lasso_intro_shown=true;SaveData.horse_collection.seed_trial();SaveData.world_seed=752026;SaveData.world_position=WorldNominal98.home()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false)
 await measure(world.player,"frontera distance180 speed0")
 world.free()
 for progress in [0,6]:
  SaveData.highest_level_completed=progress;GameState.selected_level=1
  var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level)
  await get_tree().process_frame;level.set_process(false);level.set_physics_process(false);get_tree().paused=false;Engine.time_scale=1.
  await measure(level.player,"nivel1 progress"+str(progress)+" distance180 speed0")
  level.free()
 get_tree().quit()
