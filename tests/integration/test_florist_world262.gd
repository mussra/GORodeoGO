extends "res://tests/integration/test_breeding_world256.gd"
func test_home_florist_door_reuses_legacy_quest_and_restores_control():
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_quests={};SaveData.world_position=FloristJourney138.home_door(SaveData.world_seed)+Vector2(0,70)
 await launch()
 var data:Dictionary={}
 for npc in world._npcs98():
  if npc.get("town234","")=="home" and npc.get("role234","")=="florist":data=npc;break
 assert_false(data.is_empty());world.player.position=data.position+Vector2(0,50);world._tick_npcs();assert_eq(world._npc_button.text,"Entrar a la floristería")
 var before:Vector2=world.player.position;world._open_npc(data);await wait_frames(2)
 assert_true(world._interior262 is FloristRoom262);assert_false(world.player.is_physics_processing());assert_false(world._interior262.prototype)
 var room=world._interior262;room.conversation_requested.emit();await wait_frames(2)
 assert_true(world._npc_dialog is NpcDialog);assert_eq(world._npc_dialog.get_parent(),room)
 var next:String=NpcQuests.next_for(SaveData.world_quests,world._legacy_npcs234()[1]);world._npc_dialog.accepted.emit(next);await wait_frames(3)
 assert_eq(NpcQuests.state(SaveData.world_quests,next).status,"active");assert_eq(world._npc_dialog,room);assert_false(world.player.is_physics_processing())
 room.finish();await wait_frames(2);assert_null(world._interior262);assert_null(world._npc_dialog);assert_true(world.player.is_physics_processing());assert_eq(world.player.position,before)
