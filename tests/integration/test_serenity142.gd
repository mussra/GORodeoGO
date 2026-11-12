extends GutTest
var old:Dictionary
func before_each():
 old=SaveData.horse_collection.export_state();SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.save_path="user://serenity142.dat"
func after_each():
 SaveData.horse_collection.restore(old);get_tree().paused=false;DirAccess.remove_absolute(SaveData.save_path)
func level142(number:int=1)->Node:
 GameState.selected_level=number;SaveData.dual_lasso_intro_shown=true
 var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level)
 await get_tree().process_frame;await get_tree().process_frame
 level.set_process(false);level.set_physics_process(false);level.player.set_physics_process(false)
 for b in level._active_bulls:b.set_physics_process(false);b.set_peers([])
 return level
func test_live_level_bull_reads_current_equipped_horse_calm():
 var level=await level142();var bull=level._active_bulls[0]
 for pair in [[.5,94.],[1.,88.],[2.,76.]]:
  SaveData.horse_collection.find("original")["stats"]={"calm":pair[0]}
  bull.controller=BullController.new(BullState.State.CAPTURED,bull.tuning);bull.set_player(level.player);bull._physics_process(1.)
  assert_eq(level.player.calm(),pair[0]);assert_almost_eq(bull.controller.current_nerves(),pair[1],.001)
 level.free()
func test_actual_wild_contact_still_stuns_and_drops_calm_holding_bull():
 var level=await level142(3);SaveData.horse_collection.find("original")["stats"]={"calm":2.}
 var held=level._active_bulls[0];var wild=level._active_bulls[1]
 held.controller=BullController.new(BullState.State.CALMING,held.tuning);wild.controller=BullController.new(BullState.State.ESCAPED,wild.tuning)
 wild.set_peers([held,wild]);wild.set_player(level.player);wild.global_position=level.player.global_position;wild._touching_player=false
 wild._check_player_contact();assert_gt(level.player._stun_time_remaining,0.);assert_eq(held.controller.current_state(),BullState.State.ESCAPED)
 level.free()
func test_world_rope_uses_same_serenity_without_passive_trust_or_stallion_bypass():
 SaveData.world_seed=424242;SaveData.world_generator_version=1;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_position=Vector2(0,160)
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var horse=world.WildHorseScript.new();horse.setup({"pos":world.player.position+Vector2(90,0),"temperament":.5,"traits":{"coat":0,"pattern":0,"mane":0,"eyes":0,"finish":"normal"},"stats":{"speed":260.}});world.add_child(horse);horse.set_meta("c",Vector2i(999,999));horse.set_physics_process(false);world._herd_horses[Vector2i(999,999)]=horse
 for multiplier in [.5,1.,2.]:
  SaveData.horse_collection.find("original")["stats"]={"calm":multiplier};horse.state=WorldTaming.new_state();horse.roped=true
  var bonus:float=world._affinity(horse).bonus;world._tick_taming(.1)
  assert_eq(world.player.calm(),multiplier);assert_almost_eq(float(horse.state.progress),.65*.75*.1*bonus*multiplier,.00001)
 horse.roped=false;horse.state=WorldTaming.new_state();world._tick_taming(1.);assert_eq(horse.state.progress,0.)
 horse.herd.stats.speed=290.;horse.herd.temperament=.9;horse.roped=true;horse.state=WorldTaming.new_state();world._tick_taming(.1);assert_eq(horse.state.progress,0.,"Serenity cannot bypass genetic stallion gate")
 world.free()
