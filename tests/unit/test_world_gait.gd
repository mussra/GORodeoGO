extends GutTest
func test_low_intensity_is_paso():
 assert_eq(WorldGait.update(WorldGait.PASO,0.0),WorldGait.PASO)
 assert_eq(WorldGait.update(WorldGait.PASO,0.41),WorldGait.PASO)
func test_rising_intensity_climbs_gaits():
 assert_eq(WorldGait.update(WorldGait.PASO,0.42),WorldGait.TROTE)
 assert_eq(WorldGait.update(WorldGait.TROTE,0.82),WorldGait.GALOPE)
 assert_eq(WorldGait.update(WorldGait.PASO,0.95),WorldGait.GALOPE)
func test_hysteresis_holds_gait_inside_band():
 assert_eq(WorldGait.update(WorldGait.TROTE,0.29),WorldGait.PASO)
 assert_eq(WorldGait.update(WorldGait.TROTE,0.30),WorldGait.TROTE)
 assert_eq(WorldGait.update(WorldGait.TROTE,0.41),WorldGait.TROTE)
 assert_eq(WorldGait.update(WorldGait.GALOPE,0.65),WorldGait.TROTE)
 assert_eq(WorldGait.update(WorldGait.GALOPE,0.66),WorldGait.GALOPE)
 assert_eq(WorldGait.update(WorldGait.GALOPE,0.81),WorldGait.GALOPE)
func test_speed_and_pace_are_ordered():
 assert_true(WorldGait.speed_for(WorldGait.PASO,260.0)<WorldGait.speed_for(WorldGait.TROTE,260.0))
 assert_true(WorldGait.speed_for(WorldGait.TROTE,260.0)<WorldGait.speed_for(WorldGait.GALOPE,260.0))
 assert_true(WorldGait.pace_for(WorldGait.PASO)<WorldGait.pace_for(WorldGait.GALOPE))
