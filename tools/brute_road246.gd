extends WorldRoadSurface94
func _town_roads246(point:Vector2,margin:float)->bool:
 var plans_:Dictionary=TownEnclosures227.plans(seed)
 var routes_:Array=TownNetwork234.roads(seed,plans_).duplicate()
 for item in plans_.values():routes_.append(item.road)
 for route in routes_:
  for i in route.size()-1:
   if point.distance_to(Geometry2D.get_closest_point_to_segment(point,route[i],route[i+1]))<=22.+margin:return true
 return false
