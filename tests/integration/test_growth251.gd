extends GutTest
var sut:Node
func before_each():
 sut=load("res://src/Application/save_data.gd").new();sut.save_path="user://growth251.cfg";sut.horse_collection.seed_trial();sut.horse_collection.find("original").stats={"dodge":.85}
func after_each():
 sut.free()
 if FileAccess.file_exists("user://growth251.cfg"):DirAccess.remove_absolute("user://growth251.cfg")
func test_every_mode_stays_at_max_after_hundreds_of_wins():
 var c:HorseCollection=sut.horse_collection
 c.find("original").stats={"speed":300.,"handling":1500.,"power":.9,"dodge":1.,"calm":2.}
 for mode in VictoryGrowth251.PRIMARY:
  for i in 100:
   var result:=VictoryGrowth251.apply(c,"original",mode)
   for change in result.changes254:
    assert_eq(change.after,change.high);assert_eq(change.points,0.)
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
 for spec in HorseSummary185.STATS:
  assert_gte(HorseStats.read(prize)[spec[1]],maxf(HorseStats.read(a)[spec[1]],HorseStats.read(b)[spec[1]]));assert_lte(HorseStats.read(prize)[spec[1]],float(spec[3]))
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

func test_stat_bars_are_clamped_at_both_ends_and_full_at_max():
 for spec in HorseSummary185.STATS:
  assert_eq(VictoryGrowth251.visual(spec,spec[2]-999.),0.)
  assert_eq(VictoryGrowth251.visual(spec,spec[3]),1.)
  assert_eq(VictoryGrowth251.visual(spec,spec[3]+999.),1.)
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

func test_near_max_multiple_properties_use_only_remaining_headroom():
 var h:Dictionary=sut.horse_collection.find("original")
 h.stats={"speed":300.,"power":.9,"handling":1495.5,"dodge":.999,"calm":1.999}
 var result:=VictoryGrowth251.apply(sut.horse_collection,"original","joust")
 assert_eq(result.changes254.size(),3)
 for change in result.changes254:
  assert_eq(change.after,change.high)
  assert_almost_eq(change.points,(change.high-change.before)/(change.high-change.low)*100.,.00001)
  assert_lt(change.points,2.)
 var counts:Dictionary=h.growth251.duplicate(true)
 var again:=VictoryGrowth251.apply(sut.horse_collection,"original","joust")
 assert_eq(h.growth251,counts)
 for change in again.changes254:assert_eq(change.points,0.)
 assert_eq(HorseStats.read(h).speed,300.);assert_eq(HorseStats.read(h).power,.9)
func test_legacy_excess_migrates_to_bounded_saved_stats_without_double_growth():
 var h:Dictionary=sut.horse_collection.find("original")
 h.stats={"speed":999.,"handling":9999.,"power":9.,"dodge":9.,"calm":9.}
 h.growth251={"speed":100,"handling":100,"power":100,"dodge":100,"calm":100}
 var state:Dictionary=sut.horse_collection.export_state()
 assert_true(state.horses[0].growth_capped255)
 for spec in HorseSummary185.STATS:
  assert_eq(state.horses[0].stats[spec[1]],float(spec[3]));assert_eq(HorseStats.read(h)[spec[1]],float(spec[3]))
 assert_true(sut.horse_collection.restore(state));assert_eq(sut.horse_collection.export_state(),state)
 assert_true(sut.save_progress());var cfg:=ConfigFile.new();assert_eq(cfg.load(sut.save_path),OK)
 assert_eq(cfg.get_value("horses_trial","state"),state)
func test_under_cap_legacy_migration_preserves_actual_value_and_next_diminished_gain():
 var h:Dictionary=sut.horse_collection.find("original");h.growth251={"handling":3}
 var before:float=HorseStats.read(h).handling
 var state:Dictionary=sut.horse_collection.export_state();assert_true(sut.horse_collection.restore(state))
 h=sut.horse_collection.find("original");assert_almost_eq(HorseStats.read(h).handling,before,.0001)
 var reward:=VictoryGrowth251.apply(sut.horse_collection,"original","duel")
 assert_almost_eq(reward.after-before,VictoryGrowth251.bonus("handling",4)-VictoryGrowth251.bonus("handling",3),.0001)
func test_mixed_capped_rows_animation_and_shine_never_exceed_bar():
 var h:Dictionary=sut.horse_collection.find("original");h.stats={"handling":1500.,"dodge":.999,"calm":1.99}
 var view:=HorseVictory251.new();view.reward=VictoryGrowth251.apply(sut.horse_collection,"original","joust");add_child(view);await wait_process_frames(3)
 for phase in [-.1,0.,.5,1.,1.2]:
  view._advance(phase)
  for row in view.rows254:
   assert_lte(row.bar.value,1.);assert_gte(row.bar.value,0.)
   assert_lte(row.spark.current_x,row.spark.size.x);assert_gte(row.spark.old_x,0.)
   if row.change.key=="handling":assert_eq(row.spark.old_x,row.spark.current_x)
 view.free()
func test_inheritance_averages_each_parents_effective_property_with_hard_caps():
 var a:Dictionary={"stats":{"speed":290.,"handling":700.,"power":.9,"dodge":.8,"calm":1.2},"growth251":{"power":100}}
 var b:Dictionary={"stats":{"speed":250.,"handling":1499.,"power":.6,"dodge":1.,"calm":2.},"growth251":{"speed":10000,"handling":10000}}
 var child:=HorseStats.inherit(a,b)
 for spec in HorseSummary185.STATS:
  assert_eq(child[spec[1]],(HorseStats.read(a)[spec[1]]+HorseStats.read(b)[spec[1]])*.5);assert_lte(child[spec[1]],float(spec[3]))
func test_maxed_family_prize_and_supreme_keep_caps_and_glow():
 var h:Dictionary=sut.horse_collection.find("original")
 h.stats={"speed":300.,"handling":1500.,"power":.9,"dodge":1.,"calm":2.}
 h.completed_levels=[1,2,3,4,5,6];h.race_courses251=[0,1];h.mode_wins251={"duel":1,"joust":1,"memory":1}
 var prize:=VictoryGrowth251.champion(sut.horse_collection,"original");assert_false(prize.is_empty());assert_true(prize.master251)
 for i in range(7,41):h.completed_levels.append(i)
 h.race_courses251=[0,1,2,3]
 assert_false(VictoryGrowth251.champion(sut.horse_collection,"original").is_empty());assert_true(prize.supreme251)
 for spec in HorseSummary185.STATS:assert_eq(HorseStats.read(prize)[spec[1]],float(spec[3]))
 assert_eq(HorseFinish168.style(prize),"supreme251")

func test_inheritance_average_keeps_fractional_values_and_base_for_missing_stats():
 var child:=HorseStats.inherit({"stats":{"speed":281.25}},{})
 assert_eq(child.speed,270.625);assert_eq(child.handling,900.);assert_eq(child.calm,1.)
 var improved:Dictionary={"stats":{"speed":281.25},"growth251":{"speed":1}}
 assert_almost_eq(HorseStats.inherit(improved,{}).speed,(HorseStats.read(improved).speed+260.)*.5,.00001)
func test_actual_newborn_uses_mean_and_has_no_second_growth_bonus():
 var c:HorseCollection=sut.horse_collection;c.add_trial_parents()
 c.find("trial_a").growth251={"speed":5};c.find("trial_b").growth251={"handling":5}
 var a:=HorseStats.read(c.find("trial_a"));var b:=HorseStats.read(c.find("trial_b"))
 var child:=c.breed("trial_a","trial_b",{})
 assert_false(child.is_empty());assert_true(child.growth_capped255)
 for key in HorseStats.BASE:assert_almost_eq(HorseStats.read(child)[key],(a[key]+b[key])*.5,.000000001)
 var state:=c.export_state();assert_true(c.restore(state));assert_eq(c.export_state(),state)

func test_victory_uses_same_mounted_portrait_as_horse_detail308():
 var view:=HorseVictory251.new();view.reward=VictoryGrowth251.apply(sut.horse_collection,"original","race");add_child(view);await wait_process_frames(3)
 var portrait:TextureRect=view.canvas.get_node("VictoryPortrait308")
 var reference:=TextureRect.new();HorsePortrait.apply_horse(reference,view.reward.horse,SaveData.hat_color)
 assert_eq(portrait.texture,reference.texture)
 assert_eq(portrait.material.shader,reference.material.shader)
 for key in ["coat_color","mane_color","pattern","mastery_strength251","special_finish168"]:assert_eq(portrait.material.get_shader_parameter(key),reference.material.get_shader_parameter(key))
 reference.free();view.free()
