extends GutTest
func test_florist_quests_have_order_distinct_glyph_colors_and_contact_events():
 var npc:Dictionary=NpcQuests.NPCS[1];assert_eq(npc.id,"florist")
 var states:Dictionary={};assert_true(NpcQuests.accept(states,WorldFlowers105.IDS[0]));assert_false(NpcQuests.accept(states,WorldFlowers105.IDS[1]))
 for i in 3:assert_eq(NpcQuests.record(states,"collect_flower",WorldFlowers105.IDS[0],WorldFlowers105.event_id(WorldFlowers105.IDS[0],i)).size(),1)
 assert_eq(states[WorldFlowers105.IDS[0]].status,"done");assert_true(NpcQuests.accept(states,WorldFlowers105.IDS[1]))
 assert_ne(WorldFlowers105.color_for(WorldFlowers105.IDS[0]),WorldFlowers105.color_for(WorldFlowers105.IDS[1]))
 assert_eq(NpcQuests.clean(states),states)
func test_target_positions_are_deterministic_and_outside_v3_rock():
 for seed in range(100):
  var door:Vector2=ModularWorldLayout93.world(WorldTerrain103.plan(seed).doors.florist)
  for id in WorldFlowers105.IDS:
   var positions=WorldFlowers105.positions(seed,3,door,id)
   assert_eq(positions,WorldFlowers105.positions(seed,3,door,id));assert_eq(positions.size(),3)
   for p in positions:assert_false(WorldTerrain103.blocked(seed,p,20.))
