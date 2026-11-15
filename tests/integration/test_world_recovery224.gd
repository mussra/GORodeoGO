extends GutTest
func ignore(n:Node):
 if n is Control:n.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for c in n.get_children():ignore(c)
func touch(p:Vector2,down:bool):
 var e:=InputEventScreenTouch.new();e.position=get_viewport().get_final_transform()*p;e.index=0;e.pressed=down;Input.parse_input_event(e);Input.flush_buffered_events()
func drag(p:Vector2):
 var e:=InputEventScreenDrag.new();e.position=get_viewport().get_final_transform()*p;e.index=0;Input.parse_input_event(e);Input.flush_buffered_events()
func test_actual_world_recovers_from_edge_then_town_pig_flees_and_is_captured():
 ignore(get_tree().root.get_node("GutRunner"));SaveData.save_path="user://recovery224-test-only.cfg"
 SaveData.world_seed=7781;SaveData.world_generator_version=3;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_edits.clear();SaveData.world_pig_captures.clear();SaveData.world_pigs.clear()
 SaveData.world_position=Vector2(1800,200);SaveData.world_quests={};NpcQuests.accept(SaveData.world_quests,"farmer_pigs")
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 while world._loading_world:await wait_process_frames(1)
 await wait_seconds(.7)
 world.set_process(false);world.set_physics_process(false)
 var origin:Vector2=get_viewport().get_visible_rect().size*Vector2(.15,.75)
 touch(origin,true);await wait_physics_frames(2);drag(origin+Vector2(-100,0));await wait_physics_frames(3)
 assert_gt(Input.get_vector("move_left","move_right","move_up","move_down").length(),.1)
 drag(Vector2(-20,origin.y));await wait_physics_frames(20);assert_eq(Input.get_vector("move_left","move_right","move_up","move_down"),Vector2.ZERO);assert_lt(world.player.velocity.length(),1.)
 touch(origin,true);await wait_physics_frames(2);drag(origin+Vector2(100,0));await wait_physics_frames(3);assert_gt(Input.get_action_strength("move_right"),.1)
 touch(origin+Vector2(100,0),false);await wait_physics_frames(20);assert_lt(world.player.velocity.length(),1.)
 world.player.set_physics_process(false)
 var pigs:Array=world._lasso_pigs();assert_false(pigs.is_empty())
 if pigs.is_empty():world.free();return
 var pig=pigs[0];var ridge:Dictionary=WorldTerrain103.ridge(7781,0,0);pig.position=Vector2(ridge.boxes[0].end.x+19.,200.);pig.home=pig.position;var start:Vector2=pig.position
 for i in 20:world.player.position=pig.position+Vector2(130,0);world._tick_pigs(.05)
 assert_gt(pig.position.distance_to(start),30.);assert_false(WorldTerrain103.blocked(7781,pig.position,18.))
 assert_true(world.player.lasso.prey_provider.call().has(pig));assert_eq(world.player.lasso.resolve_capture(pig.global_position),pig);assert_true(pig.roped)
 for i in 100:
  if not is_instance_valid(pig) or pig.is_queued_for_deletion():break
  world.player.position=pig.position+Vector2(130,0);world._tick_pigs(.1)
 await wait_process_frames(2);assert_false(is_instance_valid(pig));assert_eq(SaveData.world_pig_captures.size(),1)
 world.free();get_tree().paused=false;Engine.time_scale=1.;await wait_process_frames(3)
