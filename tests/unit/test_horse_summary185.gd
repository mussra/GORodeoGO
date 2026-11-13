extends GutTest
func horse_at(fraction:float)->Dictionary:
 var stats:Dictionary={}
 for spec in HorseSummary185.STATS:stats[spec[1]]=lerpf(spec[2],spec[3],fraction)
 return {"id":"test","stats":stats,"can_jump":fraction==1.,"can_dodge":fraction==1.,"learning":{"jump":fraction*100.,"dodge":fraction*100.},"completed_levels":[36,37,38,39,40] if fraction==1. else [],"mastery_rule179":1}
func test_zero_full_and_intermediate_mean():
 assert_almost_eq(HorseSummary185.average(horse_at(0.)),0.,.001)
 assert_almost_eq(HorseSummary185.average(horse_at(1.)),100.,.001)
 # Five stats and two learning values at50, campaign mastery0:350/8.
 assert_almost_eq(HorseSummary185.average(horse_at(.5)),43.75,.001)
func test_learned_skill_counts_as_full_without_gifting_mastery():
 var h:=horse_at(0.);h.can_jump=true
 assert_almost_eq(HorseSummary185.average(h),12.5,.001)
 assert_eq(HorseTraining.mastery(h,"jump"),0.)
 assert_eq(HorseMastery.percent(h),0.)
func test_summary_is_read_only_and_matches_detailed_scales():
 var h:=horse_at(.25);var before:=h.duplicate(true)
 var values:=HorseSummary185.values(h)
 assert_eq(values.size(),8)
 for i in 5:assert_almost_eq(values[i],25.,.001)
 assert_eq(h,before)
