extends GutTest
func test_herd_members_stable_related_but_distinct()->void:
 var base:Dictionary={"pos":Vector2(400,500),"traits":{"coat":3,"mane":2,"pattern":1,"eyes":0,"finish":"normal"},"temperament":.2,"stats":{"speed":260}}
 var members_:Array=WorldHerd.members(base,424242,1,2)
 assert_eq(members_,WorldHerd.members(base,424242,1,2))
 assert_gte(members_.size(),3);assert_lte(members_.size(),5)
 var ids:Array=[];var positions:Array=[];var variants:Dictionary={}
 for member in members_:
  assert_eq(member.traits.coat,3);assert_eq(member.traits.mane,2);assert_eq(member.traits.pattern,1)
  assert_false(ids.has(member.member_id));ids.append(member.member_id)
  assert_false(positions.has(member.pos));positions.append(member.pos)
  assert_lt(member.pos.distance_to(base.pos),130.0)
  variants[str(member.traits)]=true
 assert_eq(variants.size(),2,"two close genetic variants, bounded texture cost")
 assert_false(base.traits.has("legs"),"base and older source data unchanged")
 assert_false(WorldHerd.all_captured(members_,[ids[0]]))
 assert_true(WorldHerd.all_captured(members_,ids))
 assert_true(WorldHerd.members({},1,0,0).is_empty())
func test_following_slots_share_heading_but_are_not_single_file()->void:
 var a:Vector2=WorldHerd.follow_velocity(Vector2(-60,-50),Vector2.ZERO,Vector2.RIGHT,0)
 var b:Vector2=WorldHerd.follow_velocity(Vector2(-60,50),Vector2.ZERO,Vector2.RIGHT,1)
 assert_gt(a.x,200.0);assert_gt(b.x,200.0)
 assert_lte(a.length(),285.1);assert_lte(b.length(),285.1)
 var left:Vector2=WorldHerd.follow_velocity(Vector2.ZERO,Vector2(200,0),Vector2.RIGHT,0)
 var right:Vector2=WorldHerd.follow_velocity(Vector2.ZERO,Vector2(200,0),Vector2.RIGHT,1)
 assert_lt(left.y,0.0);assert_gt(right.y,0.0)
func test_wild_spots_are_colored_contrasting_and_deterministic()->void:
 for coat in HorseCollection.COATS.size():
  for variant in range(30):
   var spot:int=WorldHerd.contrasting_spots(coat,variant)
   assert_ne(spot,coat)
   var a:=Color(HorseAppearance.COLORS[coat]);var b:=Color(HorseAppearance.COLORS[spot])
   assert_gte(Vector3(a.r-b.r,a.g-b.g,a.b-b.b).length(),.48)
func test_panic_is_brief_and_recovery_allows_starting_mount_to_catch()->void:
 assert_eq(WorldHerd.escape_speed(1.0,0.0),350.0)
 assert_eq(WorldHerd.escape_speed(0.0,0.0),285.0)
 assert_eq(WorldHerd.escape_speed(0.0,6.0),235.0)
 # Worst straight-line lead after six seconds, including a1.4s panic.
 var gap:float=90.0+(350.0-260.0)*1.4+(285.0-260.0)*4.6
 var catch_seconds:float=6.0+(gap-120.0)/(260.0-235.0)
 var stamina:Dictionary=WorldStamina.new_state(.6)
 for tick in range(int(ceil(catch_seconds*60))):stamina=WorldStamina.tick(stamina,WorldGait.GALOPE,true,1.0/60.0)
 assert_lt(catch_seconds,15.0)
 assert_gt(float(stamina.value),WorldStamina.GALOPE_MIN,"reach lasso range before gait is capped")
