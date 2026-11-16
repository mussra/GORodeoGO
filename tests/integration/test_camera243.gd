extends GutTest
var holder:Node
var world:Node
var controls:WorldCamera243
func before_each():
 holder=Node.new();add_child(holder)
 world=Node.new();holder.add_child(world);world.set_physics_process(true)
 var camera:=Camera2D.new();world.add_child(camera)
 controls=WorldCamera243.new();controls.camera=camera;holder.add_child(controls)
 controls.set_process(false);controls.set_factor(1.,false)
func after_each():
 holder.free();DirAccess.remove_absolute(WorldCamera243.PREF_PATH)
func test_steps_clamp_and_reset_do_not_change_physics():
 controls.step(-1);assert_almost_eq(controls.factor,.85,.001)
 controls.step(-1);assert_almost_eq(controls.factor,.75,.001)
 controls.step(-1);assert_almost_eq(controls.factor,.75,.001);assert_true(controls.minus.disabled)
 controls.step(1);assert_almost_eq(controls.factor,.85,.001)
 controls.set_factor(5.,false);assert_eq(controls.camera.zoom,Vector2.ONE);assert_true(controls.plus.disabled)
 controls.set_factor(-2.,false);assert_eq(controls.camera.zoom,Vector2.ONE*.75)
 assert_true(world.is_physics_processing())
func test_minimum_covers_loaded_chunks_at_edges_and_ultrawide():
 for extent in [Vector2(1280,720),Vector2(1600,720),Vector2(1848,720),Vector2(720,1280)]:
  var factor:float=WorldCamera243.minimum_for(extent)
  assert_lte(maxf(extent.x,extent.y)/(2.*factor),924.01)
 assert_eq(WorldCamera243.minimum_for(Vector2(1280,720)),.75)
func test_only_noncolliding_decorative_flower_lod_changes():
 var decor=load('res://src/Presentation/world_decor.gd').new();decor.kind='flower';holder.add_child(decor)
 var tree=load('res://src/Presentation/world_decor.gd').new();tree.kind='tree';holder.add_child(tree)
 var collectible:=Node2D.new();holder.add_child(collectible)
 controls.set_factor(.75,false);assert_false(decor.visible);assert_true(tree.visible);assert_true(collectible.visible)
 controls.set_factor(1.,false);assert_true(decor.visible)
func test_preference_is_separate_and_reloaded():
 controls.set_factor(.85)
 var second:=WorldCamera243.new();holder.add_child(second);second.set_process(false)
 assert_almost_eq(second.factor,.85,.001)
 assert_eq(controls.mouse_filter,Control.MOUSE_FILTER_IGNORE)
 assert_eq(controls.minus.focus_mode,Control.FOCUS_NONE)
