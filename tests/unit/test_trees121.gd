extends GutTest
const Decor=preload("res://src/Presentation/world_decor.gd")
func test_stable_variable_and_bounded():
 var total:float=0.;var giant:int=0
 for i in 1000:
  var pos=Vector2(i*63,-i*17)
  var a=Decor.tree_multiplier121("tree",pos,752026)
  assert_eq(a,Decor.tree_multiplier121("tree",pos,752026));assert_between(a,1.,3.)
  total+=a
  if a>2.5:giant+=1
 assert_between(total/1000.,1.4,1.9);assert_lt(giant,250)
 for kind in ["bush","rock","flower","cactus"]:assert_eq(Decor.effective_scale121(kind,Vector2.ZERO,.8,1),.8)
func test_foot_anchor_and_collision_follow_same_scale():
 for kind in ["tree","pine","fruit_tree"]:
  var d=Decor.new();var pos=Vector2(60,120);d.configure121(kind,pos,1.4,752026);add_child_autofree(d)
  assert_lt((d.position+d.draw_offset*d.scale).distance_to(pos),.001)
  var box=Decor.solid_box(kind,pos,d.size_scale);var cover=Decor.occluder_box(kind,pos,d.size_scale)
  assert_almost_eq(box.end.y,d.position.y,.001)
  assert_true(cover.grow(.001).encloses(box));assert_gt(cover.size.y,60.)
  var index=WorldAwareness110.build_index({"tree":[cover]})
  assert_true(WorldAwareness110.covered(index,Vector2(60,-400),pos))
  assert_false(WorldAwareness110.covered(index,Vector2(500,-400),Vector2(500,400)))
  assert_false(WorldAwareness110.tick(WorldTaming.new_state(),150.,70.,true,1.).alert110)
  assert_gt(WorldAwareness110.tick(WorldTaming.new_state(),35.,70.,true,1.).spook,0.)
