extends Node
func _ready():run.call_deferred()
func run():
 SaveData.world_seed=752026;SaveData.world_generator_version=6
 var s:=WorldRoadSurface94.new(752026,true,false,true,6)
 var start:int=Time.get_ticks_usec();var hits:int=0
 for i in 3000:
  if s.contains(Vector2((i%100)*30.,(i/100)*35.),18.):hits+=1
 print('ROAD_BENCH ',Time.get_ticks_usec()-start,' us hits ',hits)
 get_tree().quit()
