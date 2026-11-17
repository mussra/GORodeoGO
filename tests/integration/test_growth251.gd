extends GutTest
var sut:Node
func before_each():
 sut=load("res://src/Application/save_data.gd").new();sut.save_path="user://growth251.cfg";sut.horse_collection.seed_trial()
func after_each():
 sut.free()
 if FileAccess.file_exists("user://growth251.cfg"):DirAccess.remove_absolute("user://growth251.cfg")
func test_every_mode_grows_its_property_including_above_old_max():
 var c:HorseCollection=sut.horse_collection
 c.find("original").stats={"speed":300.,"handling":1500.,"power":.9,"dodge":1.,"calm":2.}
 for mode in VictoryGrowth251.PRIMARY:
  var key:String=VictoryGrowth251.PRIMARY[mode]
  var before:float=HorseStats.read(c.find("original"))[key]
  for i in 100:
   var result:=VictoryGrowth251.apply(c,"original",mode)
   assert_eq(result.key,key);assert_gt(result.after,before);before=result.after
 assert_true(c.restore(c.export_state()))
func test_race_always_adds_horse_once_and_rewards_participating_mount():
 sut.horse_collection.add_trial_parents();sut.horse_collection.selected="trial_a"
 var ticket:Dictionary=sut.victory_ticket240("race");sut.horse_collection.selected="trial_b"
 var before:int=sut.horse_collection.horses.size()
 assert_true(sut.record_mode_victory240(ticket,0));assert_eq(sut.horse_collection.horses.size(),before+1)
 assert_eq(sut.horse_collection.find("trial_a").growth251.speed,1)
 assert_false(sut.horse_collection.find("trial_b").has("growth251"))
 assert_false(sut.record_mode_victory240(ticket,0));assert_eq(sut.horse_collection.horses.size(),before+1)
 assert_true(sut.record_mode_victory240(sut.victory_ticket240("race"),0));assert_eq(sut.horse_collection.horses.size(),before+2)
func test_failed_save_rolls_back_prize_stats_courses_and_retry_only_once():
 var before:Dictionary=sut.horse_collection.export_state();var ticket:Dictionary=sut.victory_ticket240("race")
 sut.save_path="user://missing251/fail.cfg"
 assert_false(sut.record_mode_victory240(ticket,1));assert_push_error_count(1)
 assert_eq(sut.horse_collection.export_state(),before);assert_true(sut.last_growth251.is_empty())
 sut.save_path="user://growth251.cfg";assert_true(sut.retry_victory240());assert_eq(sut.horse_collection.horses.size(),2)
 assert_true(sut.retry_victory240());assert_eq(sut.horse_collection.horses.size(),2)
 var cfg:=ConfigFile.new();assert_eq(cfg.load(sut.save_path),OK)
 var c:=HorseCollection.new();assert_true(c.restore(cfg.get_value("horses_trial","state",{})))
func test_family_progress_shared_exclusive_champion_and_glow():
 var c:HorseCollection=sut.horse_collection;c.add_trial_parents()
 var a:=c.find("trial_a");var b:=c.find("trial_b");a.traits.pattern=10;b.traits.pattern=10
 a.completed_levels=[1,2,3];b.completed_levels=[4,5,6];a.race_courses251=[0];b.race_courses251=[1]
 a.mode_wins251={"duel":1};b.mode_wins251={"joust":1,"memory":1}
 assert_true(VictoryGrowth251.family_ready(c,a));assert_false(VictoryGrowth251.full_master(a))
 var prize:=VictoryGrowth251.champion(c,a.id);assert_false(prize.is_empty());assert_eq(prize.traits.pattern,10);assert_eq(prize.origin,"mastery251");assert_true(a.master251);assert_true(b.master251)
 for spec in HorseSummary185.STATS:assert_gt(HorseStats.read(prize)[spec[1]],maxf(HorseStats.read(a)[spec[1]],HorseStats.read(b)[spec[1]]))
 assert_true(VictoryGrowth251.champion(c,b.id).is_empty());assert_true(c.restore(c.export_state()))
 assert_eq(HorseFinish168.style(c.find(a.id)),"master251")
func test_trial_and_losses_cannot_grow_or_grant():
 sut.trial_session_active=true
 assert_false(sut.record_mode_victory240(sut.victory_ticket240("race"),0));assert_eq(sut.horse_collection.horses.size(),1);assert_false(sut.horse_collection.find("original").has("growth251"))
func test_malformed_new_fields_rejected():
 var state:Dictionary=sut.horse_collection.export_state();state.horses[0].growth251={"speed":-1};assert_false(sut.horse_collection.restore(state))
 state=sut.horse_collection.export_state();state.horses[0].race_courses251=[0,0];assert_false(sut.horse_collection.restore(state))

func test_rodeo_growth_and_family_award_roll_back_and_retry():
 var h:Dictionary=sut.horse_collection.find("original");h.traits.pattern=14;h.completed_levels=[1,2,3,4,5];h.race_courses251=[0,1];h.mode_wins251={"duel":1,"joust":1,"memory":1}
 sut.points_legacy_credit_applied=true
 var before:Dictionary=sut.horse_collection.export_state();sut.save_path="user://missing251/fail.cfg"
 sut.record_victory(6,{},"original");assert_push_error_count(1);assert_false(sut.rodeo_saved241);assert_eq(sut.horse_collection.export_state(),before)
 sut.save_path="user://growth251.cfg";sut.record_victory(6,{},"original");assert_true(sut.rodeo_saved241);assert_eq(sut.horse_collection.find("original").growth251.power,1)
 assert_false(sut.horse_collection.find("lineage251_horse_14").is_empty());assert_true(sut.last_growth251.has("champion"))
func test_growth_overlay_animates_then_continue_closes():
 var view:=HorseVictory251.new();view.reward=VictoryGrowth251.apply(sut.horse_collection,"original","race");add_child(view)
 await wait_process_frames(3)
 var initial:float=view.bar.value
 await wait_seconds(2.)
 assert_gt(view.bar.value,initial);assert_almost_eq(view.progress,1.,.001);assert_true(view.spark.visible);assert_almost_eq(view.spark.phase,1.,.001)
 var button:Button=view.canvas.get_node("Continue251")
 button.pressed.emit();await wait_process_frames(2)
 assert_false(is_instance_valid(view))
 if is_instance_valid(view):view.free()

func test_stat_bars_keep_growing_past_old_max_without_rescaling_backwards():
 for spec in HorseSummary185.STATS:
  var before:float=VictoryGrowth251.visual(spec,spec[3])
  for n in 100:
   var after:float=VictoryGrowth251.visual(spec,spec[3]+VictoryGrowth251.bonus(spec[1],n+1))
   assert_gt(after,before);assert_lt(after,1.);before=after
func test_family_requires_distinct_content_and_not_other_families():
 var c:HorseCollection=sut.horse_collection;c.add_trial_parents();var a:=c.find("trial_a");var b:=c.find("trial_b")
 a.completed_levels=[1,2,3,4,5,6];b.race_courses251=[0,1];b.mode_wins251={"duel":1,"joust":1,"memory":1}
 assert_false(VictoryGrowth251.family_ready(c,a));b.traits.pattern=a.traits.pattern;assert_true(VictoryGrowth251.family_ready(c,a))
 a.completed_levels=[1,2,3];b.completed_levels=[1,2,3];assert_false(VictoryGrowth251.family_ready(c,a))

func test_master_shine_keeps_equipped_finish_and_adornments():
 var h:Dictionary={"master251":true,"special_finish168":"gold","leg_adorn169":"silver"}
 assert_eq(HorseFinish168.base_style(h),"gold");assert_eq(HorseFinish168.style(h),"gold|master251")
 var material_:ShaderMaterial=HorseAdorn169.material(h,HorseFinish168.selected_spec("walk","horse"),0)
 assert_eq(material_.get_shader_parameter("style"),1);assert_almost_eq(material_.get_shader_parameter("mastery_strength251"),.6,.001)
 assert_eq(HorseAdorn169.metal(h,"legs"),"silver")

func test_increment_color_and_glints_stay_only_in_added_bar_interval():
 var view:=HorseVictory251.new();view.reward=VictoryGrowth251.apply(sut.horse_collection,"original","race");add_child(view);await wait_process_frames(3)
 for phase in [0.,.25,.5,1.]:
  view._advance(phase)
  var spec:Array=[view.reward.title,view.reward.key,view.reward.low,view.base_high251()]
  var old:float=VictoryGrowth251.visual(spec,view.reward.before)
  var now:float=VictoryGrowth251.visual(spec,lerpf(view.reward.before,view.reward.after,phase))
  assert_almost_eq(view.spark.old_x,(view.bar.size.x-2.)*old,.001)
  assert_almost_eq(view.spark.current_x-view.spark.old_x,(view.bar.size.x-2.)*(now-old),.001)
  assert_false(view.spark.clip_contents);assert_same(view.spark.get_parent(),view.bar)
 assert_ne(view.spark.INCREMENT_COLOR,view.spark.BASE_COLOR)
 view.free()

func test_increment_rounded_and_visible_star_rooted_at_earned_segment():
 var style:=HorseVictory251.GrowthSpark251.rounded253(Color.WHITE,4.,16.)
 assert_eq(style.corner_radius_top_left,2);assert_eq(style.corner_radius_bottom_right,2)
 var view:=HorseVictory251.new();view.reward=VictoryGrowth251.apply(sut.horse_collection,"original","race");add_child(view);await wait_process_frames(3);view._advance(.5)
 var origin:Vector2=view.spark.star_origin253()
 assert_gte(origin.x,view.spark.old_x);assert_lte(origin.x,view.spark.current_x);assert_almost_eq(origin.y,view.spark.size.y*.5,.001)
 assert_eq(view.spark.effect_alpha,1.)
 view._fade_effect253(0.);assert_eq(view.spark.effect_alpha,0.)
 view.free()

func test_duel_and_joust_improve_multiple_properties_but_never_speed_or_power():
 for mode in ["duel","joust"]:
  var before:Dictionary=HorseStats.read(sut.horse_collection.find("original"));var reward:=VictoryGrowth251.apply(sut.horse_collection,"original",mode)
  assert_eq(reward.changes254.size(),2 if mode=="duel" else 3)
  var after:Dictionary=HorseStats.read(sut.horse_collection.find("original"))
  assert_eq(after.speed,before.speed);assert_eq(after.power,before.power)
  for change in reward.changes254:assert_gt(change.after,change.before);assert_true(change.key in ["handling","dodge","calm"])
func test_delta_label_preserves_integer_tens_and_fractional_actual_points():
 assert_eq(VictoryGrowth251.delta_text254({"points":2.,"before":0.,"after":2.,"low":0.,"high":100.}),"+2 pts")
 assert_eq(VictoryGrowth251.delta_text254({"points":10.,"before":0.,"after":10.,"low":0.,"high":100.}),"+10 pts")
 assert_eq(VictoryGrowth251.delta_text254({"points":.828427,"before":0.,"after":.828427,"low":0.,"high":100.}),"+0,83 pts")
func test_multi_improvement_animates_each_matching_row():
 var view:=HorseVictory251.new();view.reward=VictoryGrowth251.apply(sut.horse_collection,"original","joust");add_child(view);await wait_process_frames(3)
 assert_eq(view.rows254.size(),3);view._advance(.5)
 for row in view.rows254:assert_gt(row.spark.current_x,row.spark.old_x);assert_gt(row.bar.value,VictoryGrowth251.visual(row.spec,row.change.before))
 view._fade_effect253(0.)
 for row in view.rows254:assert_eq(row.spark.effect_alpha,0.)
 view.free()
func test_failed_multi_reward_rolls_back_all_properties_and_retries_once():
 var before:Dictionary=sut.horse_collection.export_state();sut.save_path="user://missing251/fail.cfg"
 assert_false(sut.record_mode_victory240(sut.victory_ticket240("joust")));assert_push_error_count(1);assert_eq(sut.horse_collection.export_state(),before)
 sut.save_path="user://growth251.cfg";assert_true(sut.retry_victory240());var stats:Dictionary=sut.horse_collection.find("original").growth251
 assert_eq(stats,{"dodge":1,"handling":1,"calm":1});assert_true(sut.retry_victory240());assert_eq(sut.horse_collection.find("original").growth251,stats)
