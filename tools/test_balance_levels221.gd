extends GutTest
var option:String=OS.get_environment("BALANCE221")
var rows:Array=[]
func after_all():
 var file:=FileAccess.open("/tmp/deep-research/rancho-balance221/levels-"+option+".json",FileAccess.WRITE);file.store_string(JSON.stringify(rows,"  "))
func after_each()->void:
 get_tree().paused=false
 _drive(Vector2.ZERO)
func _drive(offset:Vector2)->void:
 for action in ["move_left","move_right","move_up","move_down"]:Input.action_release(action)
 if offset.x>10:Input.action_press("move_right")
 if offset.x< -10:Input.action_press("move_left")
 if offset.y>10:Input.action_press("move_down")
 if offset.y< -10:Input.action_press("move_up")
func _live_tow_level(number:int)->void:
 SaveData.dual_lasso_intro_shown=true
 SaveData.highest_level_completed=20
 seed(int(OS.get_environment("SEED221")) if not OS.get_environment("SEED221").is_empty() else 20261105)
 seed(int(OS.get_environment("SEED221")) if not OS.get_environment("SEED221").is_empty() else 20261105)
 GameState.selected_level=number
 var level:Node=load("res://src/Presentation/level_0.tscn").instantiate()
 add_child_autofree(level)
 await wait_physics_frames(2)
 if option in ["delay2.5","legal-delay2.5"]:level._chaser_director=ChaserDirector.new(2.5)
 if option in ["speed153","legal-speed153"]:
  for bull in level._active_bulls:bull.flee_speed=153.;bull._effective_flee_speed=153.
 # Starting setup only. All subsequent positions use input and body movement.
 level.player.global_position=Vector2(0,150)
 level._on_pen_door_opened(0)
 var threat_seen:bool=false
 var captured_once:bool=false
 var stuns:int=0
 var was_stunned:bool=false
 var frame_count:int=0
 var held_frames:int=0;var drop_count:int=0;var was_holding:bool=false
 for frame in range(9000):
  frame_count=frame
  if level._bulls_returned>=1:break
  if level.player._stun_time_remaining>0 and not was_stunned:stuns+=1
  was_stunned=level.player._stun_time_remaining>0
  var held:Array=level._held_bulls()
  if not held.is_empty():held_frames+=1
  if was_holding and held.is_empty() and level._bulls_returned==0:drop_count+=1
  was_holding=not held.is_empty()
  var target:Vector2=level.pen.global_position
  if held.is_empty():
   var candidates:Array=[]
   for bull in level._active_bulls:
    if bull.controller.is_wild() and not bull._courier_active and not bull._leaving_corral:candidates.append(bull)
   candidates.sort_custom(func(a,b):return level.player.global_position.distance_to(a.global_position)<level.player.global_position.distance_to(b.global_position))
   if not candidates.is_empty():
    var bull:Node=candidates[0]
    target=bull.global_position
    if target.distance_to(level.player.global_position)<level.player.max_throw_distance-15 and (not option.begins_with("legal") or level.player.lasso.throw_guard.call()):
     level.player.lasso.resolve_capture(target)
     captured_once=captured_once or bull.controller.is_held()
   else:target=Vector2(0,-100)
  else:
   if absf(level.player.global_position.y)>170:target=Vector2(level.player.global_position.x,0)
   if level._chaser_index>=0:
    threat_seen=true
    var threat:Node=level._active_bulls[level._chaser_index]
    var away:Vector2=level.player.global_position-threat.global_position
    if away.length()<210 and level.player._dodge_cooldown<=0:
     var toward:Vector2=(target-level.player.global_position).normalized()
     var direction:Vector2=(away.normalized()+toward*.4).normalized()
     level.player.request_dodge_path(PackedVector2Array([Vector2.ZERO,direction*350]))
  _drive(target-level.player.global_position)
  await wait_physics_frames(1)
 _drive(Vector2.ZERO)
 print("LIVE_TOW ",number," sec=",frame_count/60.0," captured=",captured_once," pursuit=",threat_seen," delivered=",level._bulls_returned," stuns=",stuns)
 rows.append({"level":number,"option":option,"elapsed":frame_count/60.,"delivered":level._bulls_returned,"stuns":stuns,"drops":drop_count,"held_seconds":held_frames/60.,"capture":captured_once,"pursuit":threat_seen,"time_limit":LevelCatalog.get_level(number).time_limit_seconds})
 assert_true(captured_once)
 assert_true(threat_seen)
 assert_gte(level._bulls_returned,1,"%d one live-herd tow reaches real goal without forced nerves"%number)
 level.queue_free()
 await wait_physics_frames(2)

func test_live_tow_level_15()->void:
 await _live_tow_level(15)

func test_live_tow_level_16()->void:
 await _live_tow_level(16)

func test_live_tow_level_17()->void:
 await _live_tow_level(17)

func test_live_tow_level_18()->void:
 await _live_tow_level(18)

func test_live_tow_level_19()->void:
 await _live_tow_level(19)

