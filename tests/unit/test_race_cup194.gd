extends GutTest
func race(sequence:int,course:int=0,rank:int=1)->Dictionary:
 return {"sequence":sequence,"mode":"race","finished":true,"course":course,"rank":rank,"gates":16,"landed":1,"dodges":1,"hits":0}
func test_fresh_and_strict_migration_fail_closed():
 assert_true(RaceCup194.valid(RaceCup194.fresh()))
 for state in [{},{"rule":0,"completed":[],"last_sequence":0},{"rule":1,"completed":["win_crossing"],"last_sequence":0},{"rule":1,"completed":[],"last_sequence":-1}]:assert_false(RaceCup194.valid(state))
func test_only_current_goal_and_at_most_one_per_result():
 var state:=RaceCup194.fresh()
 assert_false(RaceCup194.record(state,race(1,3)).advanced)
 assert_eq(state.completed.size(),0)
 assert_true(RaceCup194.record(state,race(2)).advanced)
 assert_eq(state.completed,["learn_oval"])
 assert_false(RaceCup194.record(state,race(2,1)).accepted)
 assert_false(RaceCup194.record(state,race(1,1)).accepted)
func test_invalid_result_never_touches_ledger():
 for change in [{"finished":false},{"rank":0},{"rank":5},{"course":4},{"gates":15},{"landed":-1},{"sequence":0},{"hits":1.5},{"mode":"unknown"}]:
  var state:=RaceCup194.fresh();var result:=race(1);result.merge(change,true)
  assert_false(RaceCup194.record(state,result).accepted)
  assert_eq(state,RaceCup194.fresh())
func test_full_campaign_accepts_distinct_realistic_results_without_rewards():
 var state:=RaceCup194.fresh();var sequence:int=0
 for goal in RaceCup194.CHALLENGES:
  sequence+=1
  var result:Dictionary=race(sequence,maxi(0,goal.get("course",0))) if goal.mode=="race" else {"sequence":sequence,"mode":"duel","finished":true,"player_wins":2,"rival_wins":0}
  if goal.mode=="race":result.landed=2;result.dodges=3
  assert_true(RaceCup194.record(state,result).advanced)
 assert_eq(state.completed.size(),RaceCup194.CHALLENGES.size())
 assert_true(RaceCup194.current(state).is_empty())
 assert_true(RaceCup194.record(state,race(RaceCup194.CHALLENGES.size()+1)).complete)
 assert_eq(state.keys().size(),3,"No money, reward flags, horses or story objects are created")
func test_current_returns_copy_and_ledger_can_round_trip_safely():
 var state:=RaceCup194.fresh();var goal:=RaceCup194.current(state);goal.title="changed"
 assert_ne(RaceCup194.current(state).title,"changed")
 RaceCup194.record(state,race(1))
 var restored:Variant=str_to_var(var_to_str(state));assert_true(RaceCup194.valid(restored));assert_eq(restored,state)
func test_technique_goals_require_the_technique_and_duel_needs_a_completed_win():
 var result:=race(1)
 result.landed=0;assert_false(RaceCup194.matches(RaceCup194.CHALLENGES[8],result))
 result.landed=1;result.dodges=0;assert_false(RaceCup194.matches(RaceCup194.CHALLENGES[9],result))
 result.dodges=1;result.hits=1;assert_false(RaceCup194.matches(RaceCup194.CHALLENGES[11],result))
 for pair in [[1,0],[1,1],[2,2],[3,0],[-1,2]]:
  assert_false(RaceCup194.valid_result({"sequence":1,"mode":"duel","finished":true,"player_wins":pair[0],"rival_wins":pair[1]}))
 assert_false(RaceCup194.matches(RaceCup194.CHALLENGES[10],{"sequence":1,"mode":"duel","finished":true,"player_wins":1,"rival_wins":2}))
