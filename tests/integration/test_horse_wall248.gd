extends GutTest
var host:Node2D
var old_version:int
var old_seed:int
func before_each():
 old_version=SaveData.world_generator_version;old_seed=SaveData.world_seed
 SaveData.world_generator_version=6;SaveData.world_seed=752026
 host=load('res://tests/integration/horsewall_host248.gd').new();add_child(host)
func after_each():
 host.free();SaveData.world_generator_version=old_version;SaveData.world_seed=old_seed
 await wait_physics_frames(2)
func horse(pos:Vector2):
 var h=load('res://src/Presentation/wild_horse.gd').new();h.setup({'pos':pos,'traits':{'coat':1,'mane':0,'pattern':9}});host.add_child(h);h.set_physics_process(false);return h
func test_horses_take_legal_tangents_on_all_six_wall_shapes_at_three_tick_rates():
 var shapes:Dictionary={}
 for plan in TownEnclosures227.plans(752026).values():
  if shapes.has(plan.shape):continue
  shapes[plan.shape]=true
  var s:Dictionary=plan.segments[0]
  for part in plan.segments:
   if part.a.distance_to(part.b)>s.a.distance_to(s.b):s=part
  assert_false(s.is_empty())
  var normal:Vector2=(s.b-s.a).normalized().orthogonal();var mid:Vector2=(s.a+s.b)*.5
  if WorldTerrain103.blocked(752026,mid+normal*58.,18.):normal=-normal
  for hz in [30,60,120]:
   var h=horse(mid+normal*58.);h.set_meta('escape_left110',100.)
   var start:Vector2=h.position
   for i in hz:
    h.flee_velocity(-normal*230.);h._physics_process(1./hz)
    assert_false(WorldTerrain103.blocked(752026,h.position,18.),'No wall crossing at '+str(hz))
   assert_gt(start.distance_to(h.position),80.,'No stationary gallop against shape '+str(plan.shape))
   h.free()
 assert_eq(shapes.size(),6)
func test_resuming_after_distance_pause_animates_actual_movement_without_changing_capture():
 var h=horse(Vector2(-900,-900));var player:=Node2D.new();host.add_child(player);h.player_ref=player;player.position=h.position+Vector2(2000,0)
 h._physics_process(.016);assert_eq(h._art.speed_scale,0.)
 player.position=h.position-Vector2(100,0);h.approach(h.position+Vector2(120,0),.016);var start:Vector2=h.position;h._physics_process(.016)
 assert_gt(start.distance_to(h.position),0.);assert_gt(h._art.speed_scale,0.);assert_true(h._art.is_playing());assert_true(str(h._art.animation).begins_with('walk'));assert_gt(h._art.sprite_frames.get_frame_count(h._art.animation),1)
 var first:float=h._art.frame+h._art.frame_progress;await wait_seconds(.2)
 assert_ne(h._art.frame+h._art.frame_progress,first,'Frames really advance after the cull')
 h.roped=true;start=h.position;h._physics_process(.1)
 assert_eq(h.position,start);assert_eq(h.velocity,Vector2.ZERO);assert_eq(h._art.animation,'idle')
func test_legal_motion_respects_same_home_leash_when_escape_override_has_expired():
 var h=horse(Vector2(-900,-900));h.position+=Vector2.RIGHT*(WorldTaming.FLEE_LEASH-2.)
 for i in 120:h.flee_from(h.position-Vector2(100,0),1./60.);h._physics_process(1./60.);assert_lte(h.position.distance_to(h.home),WorldTaming.FLEE_LEASH+.01)
