extends SceneTree
func _initialize():
 for modular in [false,true]:
  for dark in [false,true]:
   if not modular and dark:continue
   var surface=WorldRoadSurface94.new(752026,modular,dark)
   var road:Callable=surface.contains
   var near:Vector2=ModularWorldLayout93.world(Vector2i(9,4)) if modular else Vector2.ZERO
   surface.contains(near)
   var start:int=Time.get_ticks_usec();var pos:Vector2=WorldWildRoads94.clear_spawn(near,road)
   for i in 1000:
    pos=WorldWildRoads94.safe_step(pos,near,road)
   print("ROAD94_CPU modular=",modular," dark=",dark," blocked-step-mean-us=",(Time.get_ticks_usec()-start)/1000.)
 quit()
