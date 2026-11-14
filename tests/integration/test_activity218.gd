extends GutTest
var saved219:Dictionary={}
var collection219:Dictionary={}
func snapshot219():
 saved219={}
 for property in SaveData.get_script().get_script_property_list():
  var value:Variant=SaveData.get(property.name)
  saved219[property.name]=value.duplicate(true) if value is Dictionary or value is Array else value
 collection219=SaveData.horse_collection.export_state().duplicate(true)
func restore219():
 for key in saved219:SaveData.set(key,saved219[key])
 SaveData.horse_collection.restore(collection219)
var world:Node2D
func before_each():
 snapshot219()
 SaveData.save_path="user://activity218.cfg";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_herd_town217={};SaveData.world_flora138={};SaveData.world_places144={};SaveData.world_garden212=Garden212.fresh();SaveData.world_discovered=[];SaveData.world_quests={};SaveData.world_missions={};SaveData.world_tamed=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.visible=true;world.set_process(false);world.player.set_physics_process(true)
func after_each():
 for store in [world._chunk_pending,world._chunk_built]:
  for key in store:world._discard_builder(store[key])
 world.free();DirAccess.remove_absolute(SaveData.save_path);restore219()
func test_one_pose_activity_is_cosmetic_and_waits_for_player_dialog_and_pause():
 var figure:Sprite2D=world.get_node("NominalBuildings98/Florist");var activity:NpcActivity218=figure.get_child(0)
 activity.set_process(false);assert_true(activity.clock>=90. and activity.clock<=240.)
 var origin:Vector2=figure.position;var flip:bool=figure.flip_h;activity.clock=0.
 world.player.position=figure.global_position;activity._process(.1);assert_eq(figure.position,origin);assert_eq(figure.flip_h,flip)
 world.player.position=figure.global_position+Vector2(-400,0);activity._process(.1)
 assert_ne(figure.flip_h,flip);assert_lt(figure.position.distance_to(origin),7.);assert_true(activity.duration>=5.)
 var duration:float=activity.duration;world.player.set_physics_process(false);activity._process(.25);assert_eq(activity.duration,duration)
 world.player.set_physics_process(true);activity.duration=.01;activity._process(.1);assert_eq(figure.position,origin);assert_eq(figure.flip_h,flip)
func test_lucia_uses_existing_pose_and_keeps_actions_and_progress_unchanged():
 var garden:GardenWorld212=world.garden212;garden.set_process(false);SaveData.world_garden212.stage="growing";garden.gardener.visible=true
 var activity:NpcActivity218=garden.gardener.get_child(0);activity.set_process(false)
 world.player.position=garden.plot+Vector2(-500,0);activity.clock=0.;activity._process(.1)
 assert_true(garden.pose_name in ["water","plant","harvest"]);assert_eq(SaveData.world_garden212.stage,"growing");assert_false(SaveData.world_garden212.watered)
 activity.duration=.01;activity._process(.1);assert_eq(garden.pose_name,"idle")
 garden.pose_seconds=1.;activity.clock=0.;activity._process(.1);assert_eq(garden.pose_name,"idle")
