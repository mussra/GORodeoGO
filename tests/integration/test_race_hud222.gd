extends GutTest
var race:Node2D
func after_each():
 if is_instance_valid(race):race.free()
 get_tree().paused=false;Engine.time_scale=1.
func test_compact_race_hud_hides_long_live_labels_but_keeps_controls_and_map():
 RaceCourse190.selected=0;RaceCourse190.start_selected=true
 race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race);await wait_physics_frames(2)
 race.selector.hide();race.countdown=0.;race.running=true;race.set_physics_process(false)
 for rider in race.riders:rider.set_physics_process(false)
 race._physics_process(0.)
 assert_false(race.standings.visible);assert_false(race.guidance.visible)
 assert_lt(race.info.text.length(),20);assert_lt(race.telemetry.text.length(),24)
 assert_false(race.info.text.contains("Puerta"));assert_false(race.telemetry.text.contains("m/s"))
 assert_true(race.map_view.visible);assert_false(race.map_view.expanded)
 assert_true(race.toasts.active.is_empty() and race.toasts.pending.is_empty(),"No long fence toast at start")
 race.player.try_capture(race.player.position);race._physics_process(0.)
 assert_true(race.guidance.visible);assert_eq(race.guidance.text,"Parado 1.0 s")
 assert_true(race.pause_button.visible);assert_true(race.sprint_gauge206.visible)
 race.player.slow_left=0.;race._physics_process(0.);assert_false(race.guidance.visible)
