class_name NpcActivity218
extends Node
## Local cosmetic activity only. No collisions, quests, saved position or travel changes.
signal chosen(kind:String)
var world:Node2D
var figure:Node2D
var poses:Array[String]=[]
var anchor:Vector2
var clock:float=0.
var duration:float=0.
var original_flip:bool=false
var original_position:Vector2
var rng:=RandomNumberGenerator.new()
static func attach(world_:Node,figure_:Node2D,kinds:Array[String]=[])->NpcActivity218:
 if not world_ is Node2D or not world_.has_method("_npcs98"):return null
 var activity:=NpcActivity218.new();activity.world=world_;activity.figure=figure_;activity.poses=kinds
 figure_.add_child(activity);return activity
func _ready():
 original_position=figure.position;original_flip=bool(figure.get("flip_h"));rng.seed=hash(str(figure.get_path())+str(SaveData.world_seed))
 clock=rng.randf_range(90.,240.)
func allowed()->bool:
 if not is_instance_valid(world) or not is_instance_valid(world.player) or not is_instance_valid(figure):return false
 if not world.visible or not world.player.is_physics_processing() or not figure.is_visible_in_tree():return false
 if is_instance_valid(world._npc_dialog) or is_instance_valid(world._journal140) or is_instance_valid(world._navigation):return false
 if is_instance_valid(world.garden212) and (is_instance_valid(world.garden212.panel) or world.garden212.pose_seconds>0.):return false
 var gap:float=world.player.global_position.distance_to(figure.global_position)
 return gap>180. and gap<1400.
func _process(delta:float):
 if not allowed():return
 var step:float=minf(delta,.25)
 if duration>0.:
  duration=maxf(0.,duration-step)
  if duration<=0.:
   if not poses.is_empty():chosen.emit("idle")
   else:figure.position=original_position;figure.set("flip_h",original_flip)
  return
 clock-=step
 if clock>0.:return
 clock=rng.randf_range(90.,240.);duration=rng.randf_range(5.,10.)
 if not poses.is_empty():chosen.emit(poses[rng.randi_range(0,poses.size()-1)])
 else:
  # With one-pose sheets, only turn or shift a few pixels. No claim of a walking animation.
  figure.set("flip_h",not original_flip)
  figure.position=original_position+Vector2(rng.randf_range(-6.,6.),0.)
