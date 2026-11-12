extends GutTest
const Horse=preload("res://src/Presentation/wild_horse.gd")
const Art=preload("res://src/Presentation/wild_horse_art.gd")
func test_sprite_boundary_jitter_holds_view_and_frame_phase():
 var art=Art.new();art.traits={"coat":1,"mane":0,"pattern":0};add_child_autofree(art)
 art.grazing=false;art.set_motion107(Vector2(260,0));art.walk_dir="side";art._update_anim()
 for boundary in [atan2(1.,1.6),atan2(1.,.45)]:
  art.walk_dir="diag_up";art._update_anim()
  for i in 180:
   art.update_heading129(Vector2.from_angle(-boundary+(.00001 if i%2==0 else -.00001))*260.,1./60.)
   assert_eq(art.walk_dir,"diag_up")
 art.walk_dir="side";art.flip_h=false;art._update_anim();art.set_frame_and_progress(4,.4)
 art.update_heading129(Vector2(0,-260),.099)
 assert_eq(art.walk_dir,"side","waits until sustained")
 art.update_heading129(Vector2(0,-260),.001)
 assert_eq(art.walk_dir,"up","exact hold time transitions")
 assert_eq(art.frame,4);assert_almost_eq(art.frame_progress,.4,.001,"no gait reset on direction change")
 art.update_heading129(Vector2.ZERO,1.)
 assert_eq(art.walk_dir,"up","zero movement cannot invent down pose")
func test_one_frame_direction_spikes_do_not_flash_or_mirror():
 var art=Art.new();add_child_autofree(art);art.walk_dir="up";art.flip_h=false
 for i in 120:
  art.update_heading129(Vector2(-260,0) if i%2==0 else Vector2(260,0),1./60.)
  assert_eq(art.walk_dir,"up");assert_false(art.flip_h)
func horse():
 var h=Horse.new();h.setup({"pos":Vector2.ZERO,"traits":{"coat":1,"mane":0,"pattern":0}});add_child_autofree(h);h.set_physics_process(false);h.road_provider94=func(_p,_r):return false
 h.set_meta("escape_left110",6.);return h
func test_pursuit_turns_are_bounded_and_sprite_matches_final_motion():
 var h=horse();var previous=Vector2.ZERO;var turns:int=0;var last:String=""
 for i in 360:
  # Threat crosses axis and diagonals; includes a sudden reversal.
  var heading=Vector2.from_angle(i*.018+(PI if i>180 else 0.))
  h.flee_from(h.position-heading*180.,1./60.);h._physics_process(1./60.)
  if previous.length()>12.:
   assert_lte(absf(angle_difference(previous.angle(),h.velocity.angle())),WildHeading129.TURN_RATE/60.+.0001)
  assert_gt(h.velocity.length(),220.,"smooth turn must not freeze escape")
  previous=h.velocity
  var pose=h._art.walk_dir+str(h._art.flip_h)
  if not last.is_empty() and pose!=last:turns+=1
  last=pose
 assert_lt(turns,30,"views change with sustained turns, not every tick")
 h.roped=true;var at=h.position;h._physics_process(.1)
 assert_eq(h.position,at);assert_eq(h.velocity,Vector2.ZERO)
 assert_eq(h._steered129,Vector2.ZERO,"capture clears momentum immediately")
func test_flee_velocity_and_single_horse_use_identical_visual_route():
 var a=horse();var b=horse()
 for i in 120:
  var v=Vector2.from_angle(i*.01)*230.
  a.flee_from(a.position-v,.016);b.flee_velocity(v);a._physics_process(.016);b._physics_process(.016)
  assert_almost_eq(a.velocity.x,b.velocity.x,.02);assert_almost_eq(a.velocity.y,b.velocity.y,.02)
  assert_eq(a._art.walk_dir,b._art.walk_dir);assert_eq(a._art.flip_h,b._art.flip_h)
