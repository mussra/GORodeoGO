class_name WorldPaths
extends RefCounted
## Additive local access lanes. Seeded trunk/content and save schema are untouched.
## House art doorway is at 37% width, threshold at bottom of the sprite.
const RANCH_DOOR=Vector2(-67,-123)
const ZONE_DOORS=[Vector2(126.8,436),Vector2(291.8,446)]
static func access_lanes(seed:int)->Array:
 var junction=Vector2(WorldMap.branch_x_at(seed,480),480)
 var west=Vector2(126.8,480)
 return [
  PackedVector2Array([Vector2(-67,WorldMap.trail_y_at(seed,-67)),RANCH_DOOR]),
  PackedVector2Array([junction,west,ZONE_DOORS[0]]),
  PackedVector2Array([junction,Vector2(291.8,480),ZONE_DOORS[1]])]
static func distance_to_access(seed:int,pos:Vector2)->float:
 var nearest=INF
 for lane in access_lanes(seed):
  for i in lane.size()-1:nearest=minf(nearest,pos.distance_to(Geometry2D.get_closest_point_to_segment(pos,lane[i],lane[i+1])))
 return nearest
