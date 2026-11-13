extends GutTest
func test_first_wins_keep_earned_policy_repeats_cannot_farm_8500():
 for level in range(1,21):
  assert_eq(ProgressionEconomy165.victory_points(level,level-1),EquipmentCatalog.REWARDS[level])
  assert_between(ProgressionEconomy165.victory_points(level,20),10,400)
 assert_eq(ProgressionEconomy165.victory_points(20,20),400)
 assert_eq(ProgressionEconomy165.victory_points(41,40),0)
func test_currency_alone_never_unlocks_cosmetics_and_progress_is_not_consumed():
 var id:String="finish_ice";var missing:=ProgressionEconomy165.missing(id,1000000,0,0,0)
 assert_eq(missing,{"pigs":280,"goats":220,"contracts":56})
 assert_eq(ProgressionEconomy165.missing(id,66000,280,220,56),{})
 assert_eq(ProgressionEconomy165.missing(id,65999,280,220,56),{"points":1})
 assert_eq(ProgressionEconomy165.missing("unknown",1000000,999,999,999),{"unknown":true})
func test_repeat_contract_needs_acceptance_new_capture_ids_and_claim_only_once():
 var state:=ProgressionEconomy165.new_contract()
 assert_false(ProgressionEconomy165.record(state,"pig","old"));assert_true(ProgressionEconomy165.accept(state));assert_false(ProgressionEconomy165.accept(state))
 assert_false(ProgressionEconomy165.record(state,"goat","wrong"))
 for i in 5:assert_true(ProgressionEconomy165.record(state,"pig","pig%d"%i));assert_false(ProgressionEconomy165.record(state,"pig","pig%d"%i))
 assert_true(state.ready);assert_false(state.active);assert_false(ProgressionEconomy165.accept(state))
 assert_eq(ProgressionEconomy165.claim(state),400);assert_eq(ProgressionEconomy165.claim(state),0);assert_eq(state.completed,1);assert_eq(ProgressionEconomy165.target(state),"goat")
 assert_true(ProgressionEconomy165.accept(state))
 for i in 5:assert_true(ProgressionEconomy165.record(state,"goat","goat%d"%i))
 assert_eq(ProgressionEconomy165.claim(state),400);assert_eq(state.completed,2);assert_eq(ProgressionEconomy165.target(state),"pig")
func test_contract_state_roundtrips_and_invalid_data_cannot_award_reward():
 assert_eq(ProgressionEconomy165.clean({}),ProgressionEconomy165.new_contract())
 var state:=ProgressionEconomy165.new_contract();ProgressionEconomy165.accept(state);ProgressionEconomy165.record(state,"pig","p1")
 assert_eq(ProgressionEconomy165.clean(state),state)
 var invalid:Dictionary={"version":1,"completed":0,"active":false,"ready":true,"events":["same","same","same","same","same"]}
 assert_eq(ProgressionEconomy165.claim(ProgressionEconomy165.clean(invalid)),0)
 for i in range(2,6):ProgressionEconomy165.record(state,"pig","p%d"%i)
 assert_eq(ProgressionEconomy165.clean(state),state)
