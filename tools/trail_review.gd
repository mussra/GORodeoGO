extends SceneTree
## Visual evidence for the trail fix: level 20 dodge route crossing a fence.
## Captures the skid trail before the fence, mid-jump and after the route completes.
var frame:int=0
var stage:int=0
var stage_frame:int=0
var level:Node
var player:Node2D
var mid_shot_done:bool=false
func _initialize()->void:
 call_deferred("setup")
func setup()->void:
 root.size=Vector2i(1599,719)
 var SD:Node=root.get_node("SaveData")
 SD.save_path="user://trail-review-save.dat"
 SD.debug_mode=true
 SD.highest_level_completed=20
 SD.dual_lasso_intro_shown=true
 SD.equipment_equipped["whip"]="whip_long" # 420px reach: the route must fit the trace limit
 var sel:Dictionary=SD.horse_collection.find(SD.horse_collection.selected)
 sel["can_jump"]=true;sel["can_dodge"]=true
 root.get_node("GameState").selected_level=20
 level=(load("res://src/Presentation/level_0.tscn") as PackedScene).instantiate()
 root.add_child(level)
func _process(_delta:float)->bool:
 frame+=1
 if stage==0 and frame>=30:
  player=level.get_node("Player")
  for n in level.get_children():
   if n!=player and n is Node2D and n.has_method("_update_collision"):
    n.set_physics_process(false) # freeze bulls: trail rendering review, not herd AI
  var fence:=find_fence()
  print("FENCE AT ",fence.global_position if fence!=null else "NONE"," PLAYER ",player.global_position)
  # Level 20 spawns its fence at world origin, on top of the player spawn: back off first.
  if fence!=null:player.global_position=fence.global_position+Vector2(0,-240)
  var target:Vector2
  if fence!=null:
   var to_fence:Vector2=fence.global_position-player.global_position
   target=to_fence.normalized()*(to_fence.length()+120.0)
  else:
   target=Vector2(400,0)
  # Curved route through the fence: slight S so the trail is clearly visible.
  var pts:=PackedVector2Array([Vector2.ZERO])
  for i in range(1,9):
   var t:=float(i)/8.0
   pts.append(target*t+Vector2(sin(t*PI)*50.0,0))
  print("DODGE REQ ",player.request_dodge_path(pts))
  stage=1;return false
 if stage==1:
  if not mid_shot_done and player.get("_dodge_path").size()>2 and player.get("_skid_trail").size()>14:
   mid_shot_done=true
   shot("/downloads/trail-mid-ride.png")
  if player.get("_jump_time")>0:
   shot("/downloads/trail-mid-jump.png")
   stage=2;return false
  if player.get("_dodge_path").is_empty():
   print("PATH ENDED WITHOUT JUMP, POS ",player.global_position," TRAIL ",player.get("_skid_trail").size())
   shot("/downloads/trail-route-end.png")
   quit()
  return false
 if stage==2:
  var path:Array=player.get("_dodge_path")
  if path.is_empty() and player.get("_jump_time")<=0:
   shot("/downloads/trail-route-end.png")
   print("TRAIL SIZE ",player.get("_skid_trail").size()," POS ",player.global_position)
   quit()
  return false
 if frame>2400:
  print("TIMEOUT POS ",player.global_position," PATH ",player.get("_dodge_path").size()," JUMP ",player.get("_jump_time"))
  shot("/downloads/trail-timeout.png")
  quit()
 return false
func find_fence()->Node2D:
 var stack:Array=[level]
 while not stack.is_empty():
  var n:Node=stack.pop_back()
  if n is Node2D and n.get("fence_size")!=null:return n
  stack.append_array(n.get_children())
 return null
func shot(path:String)->void:
 var img:Image=root.get_texture().get_image()
 img.save_png(path)
 print("SHOT ",path," ",img.get_size())
