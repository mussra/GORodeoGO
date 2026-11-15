extends "res://tests/integration/test_herd_migration226.gd"
func test_v5_has_one_loco_two_service_accesses_and_horse_panel_resumes_play_on_back():
 SaveData.world_generator_version=5;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_garden212=Garden212.fresh();SaveData.world_position=WorldNominal98.home()
 await launch()
 var npcs:Array=world._npcs98();assert_eq(npcs.filter(func(n):return n.has("cousin140")).size(),1);assert_eq(npcs.filter(func(n):return n.has("service231")).size(),2)
 var layer:TownServices231
 for node in world.get_children():
  if node is TownServices231:layer=node
 assert_not_null(layer)
 for id in ["west140","east140"]:
  world.player.position=SaveData.world_cousins140.doors[id];layer._process(0.);assert_true(layer.nodes.has(id));assert_true(layer.nodes[id].get_child_count()>=5)
  world._open_service231(id);assert_false(world.player.is_physics_processing());assert_true(world._npc_dialog is TownServicePanel231)
  world._npc_dialog.open_requested.emit();await wait_frames(2)
  if id=="west140":
   assert_true(world._npc_dialog is HorsePanel);world._npc_dialog.go_back()
  else:
   assert_true(world._npc_dialog is EquipmentPanel);world._npc_dialog.closed.emit()
  await wait_frames(2);assert_true(world.player.is_physics_processing());assert_null(world._npc_dialog)
func test_v4_keeps_four_loco_and_has_no_service_relocation():
 SaveData.world_generator_version=4;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_garden212=Garden212.fresh();SaveData.world_position=WorldNominal98.home()
 await launch();var npcs:Array=world._npcs98();assert_eq(npcs.filter(func(n):return n.has("cousin140")).size(),4);assert_eq(npcs.filter(func(n):return n.has("service231")).size(),0)
