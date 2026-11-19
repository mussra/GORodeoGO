class_name TownLayer227
extends Node2D
## Gate posts, signs and shared access roads. Walls stream through Mountains103.
var seed:int
func _ready():z_index=-5;texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED
func _draw():
 for plan in TownEnclosures227.plans(seed).values():
  var road:PackedVector2Array=plan.road
  for i in road.size()-1:
   if road[i].distance_to(road[i+1])>1.:ContinuousRoadArt.access(self,PackedVector2Array([road[i],road[i+1]]),40.)
  var look:=TownIdentity215.look(SaveData.world_cousins140,plan.id)
  for post in plan.posts:
   if look.is_empty():continue
   TownArt315.post(self,post,post.x<plan.gate.x,look)
 # Town name and roles now use one screen-space placard (TownSign242).
