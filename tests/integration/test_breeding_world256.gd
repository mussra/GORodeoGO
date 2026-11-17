extends "res://tests/integration/test_herd_migration226.gd"
func test_exterior_door_opens_workshop_and_exit_restores_player():
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_position=SaddleryExterior256.DOOR+Vector2(0,80)
 await launch()
 assert_eq(world.get_children().filter(func(n):return n is SaddleryExterior256).size(),1)
 world.player.position=SaddleryExterior256.DOOR+Vector2(0,80);world._tick_npcs();assert_eq(world._npc_button.text,"Entrar al taller");world._open_npc(SaddleryExterior256.definition())
 assert_true(world._npc_dialog is SaddleryRoom256);assert_false(world.player.is_physics_processing())
 world._npc_dialog.finish();await wait_frames(2);assert_null(world._npc_dialog);assert_true(world.player.is_physics_processing())
func test_mentor_and_book_from_world_menu_restore_control_and_pause():
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_position=BreedingAdvice256.mentor_position()+Vector2(0,80)
 await launch()
 world.player.position=BreedingAdvice256.mentor_position()+Vector2(0,80);world._open_npc(BreedingAdvice256.mentor())
 assert_true(world._npc_dialog is BreedingBook256);assert_true(world._npc_dialog.tutorial);assert_eq(world._npc_dialog.page,0)
 world._npc_dialog.finish();await wait_frames(2);assert_true(world.player.is_physics_processing())
 world._open_navigation();assert_true(world._navigation.entries.any(func(e):return e.id=="book256"))
 world._navigation.queue_free();world._navigation_selected("book256");assert_true(get_tree().paused)
 var books:Array=world._hud.get_children().filter(func(c):return c is BreedingBook256);assert_eq(books.size(),1)
 books[0].finish();await wait_frames(2);assert_false(get_tree().paused)
