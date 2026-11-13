extends GutTest
func test_cards_are_separate_structured_read_only_and_complete_has_correct_contact():
 var states:Dictionary={"florist_blue105":{"status":"done","count":3,"events":["a","b","c"]},"east_flower":{"status":"active","count":0,"events":[]}}
 var contract:=ProgressionEconomy165.new_contract();var before:=var_to_str([states,contract]);var panel:=QuestDetails179.new();add_child(panel);panel.size=Vector2(570,300)
 panel.update_states(states,contract,{})
 assert_eq(panel.rows.get_child_count(),3)
 var first:DetailCard179=panel.rows.get_child(0)
 assert_eq(first.heading.text,NpcQuests.QUESTS.florist_blue105.title)
 assert_eq(first.progress.value,3.)
 assert_true(first.footer.text.contains("florista"))
 assert_eq(var_to_str([states,contract]),before)
 panel.update_states(states,contract,{})
 assert_eq(panel.rows.get_child(0),first,"unchanged refresh keeps same cards and scroll")
 panel.free()
func test_ready_contract_preserves_five_of_five_and_reward_without_claiming():
 var state:=ProgressionEconomy165.new_contract();ProgressionEconomy165.accept(state)
 for i in 5:ProgressionEconomy165.record(state,"pig",str(i))
 var panel:=QuestDetails179.new();add_child(panel);panel.update_states({},state,{})
 var card:DetailCard179=panel.rows.get_child(1)
 assert_eq(card.progress.value,5.)
 assert_true(card.footer.text.contains("400"));assert_true(card.footer.text.contains("Listo"));assert_true(state.ready)
 panel.free()
