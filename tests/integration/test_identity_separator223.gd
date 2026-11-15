extends GutTest
func test_shared_marker_only_belongs_to_human_riders():
 for path in ["duel193","joust196","race190"]:
  var scene=load("res://src/Presentation/"+path+".tscn").instantiate();add_child(scene);await wait_physics_frames(2)
  assert_true(scene.player.has_node("PlayerMarker223"))
  for rider in scene.riders:
   if rider!=scene.player:assert_false(rider.has_node("PlayerMarker223"))
  scene.free();await wait_physics_frames(2)
 for path in ["jump_memory207","level_0"]:
  var scene=load("res://src/Presentation/"+path+".tscn").instantiate();add_child(scene);await wait_physics_frames(2)
  assert_true(scene.player.has_node("PlayerMarker223"));scene.free();await wait_physics_frames(2)
func test_physical_divider_blocks_steering_and_traced_regate_but_not_rope():
 var scene=load("res://src/Presentation/joust196.tscn").instantiate();add_child(scene);await wait_physics_frames(2)
 scene.countdown=0.;scene.running=true;scene.set_physics_process(false)
 assert_true(scene.has_node("LaneDivider223"));assert_eq(scene.get_node("LaneDivider223").collision_layer,HorseJump.FENCE_LAYER)
 for side in 2:
  var rider=scene.riders[side];rider.attack_cooldown=99.;rider.position=Vector2(-200,-45 if side==0 else 45);rider.velocity=Vector2.ZERO
  if side==0:Input.action_press("move_down")
  else:rider.ai=false;Input.action_release("move_down");Input.action_press("move_up")
  for other in scene.riders:other.set_physics_process(other==rider)
  await wait_physics_frames(45)
  assert_true(rider.position.y<=-24. if side==0 else rider.position.y>=24.)
  Input.action_release("move_down");Input.action_release("move_up")
  rider.dodge.cooldown=0.;rider.dodge.request_path(PackedVector2Array([Vector2.ZERO,Vector2(0,250 if side==0 else -250)]))
  await wait_physics_frames(30);assert_true(rider.position.y<=-24. if side==0 else rider.position.y>=24.)
 for rider in scene.riders:rider.set_physics_process(false)
 scene.player.position=Vector2(-50,-45);scene.riders[1].position=Vector2(50,45);scene.player.attack_cooldown=0.;scene.player.velocity=Vector2.ZERO
 var offset:Vector2=scene.riders[1].position-scene.player.position
 scene.player.lasso.aim_direction=offset.normalized();scene.player.lasso._start_charging();scene.player.lasso._charge_distance=offset.length();scene.player.lasso._release_throw()
 await wait_physics_frames(26);assert_eq(scene.pending,[0])
 scene.free();await wait_physics_frames(2)
