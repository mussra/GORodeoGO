extends GutTest
func test_independent_towns_targets_and_legacy_quests_unchanged():
 var a=RegionalVillages123.definitions("first","meadow");var b=RegionalVillages123.definitions("second","mountain")
 var fa=RegionalVillages123.quest_id("first","farmer");var fb=RegionalVillages123.quest_id("second","farmer")
 assert_eq(a[fa].target,"pig");assert_eq(b[fb].target,"goat")
 var states={};assert_true(NpcQuests.accept(states,fa,a));NpcQuests.record(states,"capture_animal","pig","pig1",a)
 assert_eq(states[fa].count,1);assert_false(states.has(fb));assert_false(RegionalVillages123.all_done(states,RegionalVillages123.npc("first","meadow","farmer")))
 assert_eq(NpcQuests.NPCS[0].quests,["farmer_pigs","farmer_goats"])
func test_completion_survives_serialization_and_does_not_reopen():
 var defs=RegionalVillages123.definitions("first","meadow");var id=RegionalVillages123.quest_id("first","florist");var states={};NpcQuests.accept(states,id,defs)
 for n in 3:NpcQuests.record(states,"collect_flower","first:blue1","flower%d"%n,defs)
 var raw=RegionalVillages123.pack({"first":states});var decoded=JSON.parse_string(JSON.stringify(raw));var restored=RegionalVillages123.unpack(decoded,{"first":"meadow","second":"mountain"})
 assert_true(RegionalVillages123.all_done(restored.first,RegionalVillages123.npc("first","meadow","florist")))
 assert_false(NpcQuests.accept(restored.first,id,defs));assert_false(RegionalVillages123.all_done(restored.second,RegionalVillages123.npc("second","mountain","florist")))
func test_fields_are_stable_species_limited_and_have_unique_ids():
 var a=RegionalFlowerField123.plan("first","meadow",752026,Vector2.ZERO);var b=RegionalFlowerField123.plan("second","mountain",752026,Vector2.ZERO)
 assert_eq(a,RegionalFlowerField123.plan("first","meadow",752026,Vector2.ZERO));var types={};var ids={}
 for f in a:assert_eq(f.type,"blue1")
 for f in b:types[f.type]=true;assert_false(ids.has(f.id));ids[f.id]=true;assert_true(RegionalFlowerField123.FLOWERS.has(f.type))
 assert_eq(types.size(),10)
func test_finished_dialog_is_constant_only_for_opted_in_v3_npcs():
 var npc=NpcQuests.NPCS[1].duplicate(true);npc.regional_close123=true;var states={}
 for id in npc.quests:states[id]={"status":"done","count":3,"events":["a","b","c"]}
 var dialog=NpcDialog.new();dialog.setup(npc,states);add_child_autofree(dialog)
 assert_eq(dialog.get_node("QuestBody").text,RegionalVillages123.THANKS)
 for child in dialog.get_children():
  if child is Button and child.text=="Aceptar encargo":assert_false(child.visible)
 npc.erase("regional_close123")
 var legacy=NpcDialog.new();legacy.setup(npc,states);add_child_autofree(legacy)
 assert_ne(legacy.get_node("QuestBody").text,RegionalVillages123.THANKS)
 states[npc.quests[0]].status="active";npc.regional_close123=true
 assert_false(RegionalVillages123.all_done(states,npc))
