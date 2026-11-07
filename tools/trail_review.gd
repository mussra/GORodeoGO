extends SceneTree
## Visual evidence for the trail fix: level 20 dodge route crossing a fence.
## Captures the skid trail before the fence, mid-jump and after the route completes.
var frame:int=0
var stage:int=0
var stage_frame:int=0
var level:Node
var player:Node2D
func _initialize()->void:
 call_deferred("setup")
func setup()->void:
 root.content_scale_size=Vector2i(1599,719)
 var SD:Node=root.get_node("SaveData")
 SD.save_path="user://trail-review-save.dat"
 SD.debug_mode=true
 SD.highest_level_completed=20
 SD.dual_lasso_intro_shown=true
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
  if fence!=null:player.global_position=fence.global_position+Vector2(0,-260)
  var target:Vector2
  if fence!=null:
   var to_fence:Vector2=fence.global_position-player.global_position
   target=to_fence.normalized()*(to_fence.length()+150.0)
  else:
   target=Vector2(400,0)
  # Curved route through the fence: slight S so the trail is clearly visible.
  var pts:=PackedVector2Array([Vector2.ZERO])
  for i in range(1,9):
   var t:=float(i)/8.0
   pts.append(target*t+Vector2(0,sin(t*PI)*60.0))
  print("DODGE REQ ",player.request_dodge_path(pts))
  stage=1;return false
 if stage==1:
  if player.get("_jump_time")>0:
   shot("/downloads/trail-mid-jump.png")
   stage=2;return false
  if player.get("_dodge_path").size()>0 and player.get("_skid_trail").size()>14:
   shot("/downloads/trail-mid-ride.png")
   stage=1;# keep waiting for the jump
  return false
 if stage==2:
  var path:Array=player.get("_dodge_path")
  if path.is_empty() and player.get("_jump_time")<=0:
   shot("/downloads/trail-route-end.png")
   print("TRAIL SIZE ",player.get("_skid_trail").size()," POS ",player.global_position)
   quit()
  return false
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
