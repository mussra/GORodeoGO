extends Node
func _ready():run.call_deferred()
func run():
 SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_discovered=[]
 for x in range(-1,8):
  for y in range(-1,5):SaveData.world_discovered.append(WorldMap.chunk_key(x,y))
 for pair in [[Vector2(500,3000),Vector2(6500,3000)],[Vector2(700,220),Vector2(6000,470)]]:
  var stamp:=Time.get_ticks_msec();var route:=SiestaRoute163.frontier(pair[0],pair[1]);print('ROUTE170 ',pair,' result=',not route.is_empty(),' ms=',Time.get_ticks_msec()-stamp,' length=',route.get('length',0))
 get_tree().quit()
