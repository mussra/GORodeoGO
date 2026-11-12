extends GutTest
const Decor=preload("res://src/Presentation/world_decor.gd")
func test_trunk_blocks_but_canopy_does_not_and_road_growth_is_safe():
 SaveData.horse_collection.seed_trial()
 var w=Node2D.new();w.y_sort_enabled=true;add_child_autofree(w)
 var d=Decor.new();d.configure121("tree",Vector2.ZERO,1.4,752026);w.add_child(d)
 var box=Decor.solid_box("tree",Vector2.ZERO,d.size_scale);WorldPhysics.add_box(w,box)
 var actor=load("res://src/Presentation/world_player.gd").new();w.add_child(actor);actor.set_physics_process(false)
 await wait_physics_frames(2)
 actor.position=Vector2(0,box.end.y+60)
 assert_true(actor.test_move(actor.global_transform,Vector2(0,-120)))
 actor.position=Vector2(100,-60)
 assert_false(actor.test_move(actor.global_transform,Vector2(-180,0)),"Canopy is not a solid wall")
 var surface=WorldRoadSurface94.new(752026,true)
 for x in range(-400,401,40):
  for y in range(-400,401,40):
   var pos=Vector2(x,y)
   if surface.contains(pos,45.):continue
   var sc=Decor.road_safe_scale121("tree",pos,1.,3.,surface)
   var rect=Decor.solid_box("tree",pos,sc)
   for xx in [rect.position.x,rect.get_center().x,rect.end.x]:
    for yy in [rect.position.y,rect.get_center().y,rect.end.y]:assert_false(surface.contains(Vector2(xx,yy),8.))
