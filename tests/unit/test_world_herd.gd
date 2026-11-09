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
