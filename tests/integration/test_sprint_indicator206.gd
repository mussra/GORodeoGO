extends GutTest
var scene:Node
func after_each():
 if is_instance_valid(scene):scene.free()
 Engine.time_scale=1.;get_tree().paused=false
func test_clock_lives_only_in_shared_lightning_indicator():
 for mode in ["race190","joust196"]:
  RaceCourse190.start_selected=true
  scene=load("res://src/Presentation/"+mode+".tscn").instantiate();add_child(scene)
  await wait_physics_frames(2)
  scene.set_physics_process(false)
  for rider in scene.riders:rider.set_physics_process(false)
  assert_eq(scene.sprint_gauge206.skill,"stamina","reference lightning artwork, sprint ratio")
  assert_eq(scene.sprint_gauge206.mouse_filter,Control.MOUSE_FILTER_IGNORE,"indicator does not change gesture")
  for cooldown in [2.5,1.25,0.]:
   scene.player.dodge.cooldown=cooldown;scene._physics_process(0.)
   assert_almost_eq(scene.sprint_gauge206.ratio,1.-cooldown/2.5,.001)
  if mode=="race190":assert_false(scene.telemetry.text.contains("Regate"))
  scene.free();scene=null
