extends Node2D
const SEED:int=7781
func road_surface_contains94(_p:Vector2,_margin:float)->bool:return false
func mountain_step103(a:Vector2,b:Vector2)->Vector2:return WorldTerrain103.safe_step(SEED,a,b)
func mountain_spawn103(p:Vector2)->Vector2:return WorldTerrain103.clear_spawn(SEED,p)
