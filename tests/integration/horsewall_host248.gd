extends Node2D
var seed_:int=752026
func road_surface_contains94(_p:Vector2,_m:float=0.)->bool:return false
func mountain_step103(a:Vector2,b:Vector2)->Vector2:return WorldTerrain103.safe_step(seed_,a,b)
