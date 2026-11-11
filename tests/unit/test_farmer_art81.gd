extends GutTest
func test_shared_art_and_contained_dialog():
 var npc=WorldNpc.new();npc.setup(NpcQuests.NPCS[0]);add_child_autofree(npc)
 assert_false(NpcQuests.NPCS[0].placeholder)
 assert_eq(npc.get_node("FarmerArt").texture,WorldNpc.PORTRAIT)
 assert_almost_eq(npc.get_node("FarmerArt").scale.y*WorldNpc.PORTRAIT.get_height(),90.0,.01)
 var dialog=NpcDialog.new();dialog.setup(NpcQuests.NPCS[0],{});add_child_autofree(dialog)
 var portrait=dialog.get_node("FarmerPortrait")
 assert_eq(portrait.texture,WorldNpc.PORTRAIT)
 assert_lt(portrait.position.x+WorldNpc.PORTRAIT.get_width()*portrait.scale.x/2,170.0)
 assert_lt(portrait.position.y+WorldNpc.PORTRAIT.get_height()*portrait.scale.y/2,275.0)
 assert_eq(dialog.get_node("QuestBody").text,NpcQuests.QUESTS.farmer_pigs.text)
