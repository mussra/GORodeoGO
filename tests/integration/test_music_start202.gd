extends GutTest
var scene:Node
func after_each():
 if is_instance_valid(scene):scene.free()
 RanchMusic.set_enabled(true);RanchMusic.set_paused(false)
 get_tree().paused=false;Engine.time_scale=1.
 await wait_physics_frames(2)
func test_race_silent_in_selector_and_countdown_then_starts_at_go():
 RanchMusic.play_context("menu")
 RaceCourse190.selected=0;RaceCourse190.start_selected=false
 scene=load("res://src/Presentation/race190.tscn").instantiate();add_child(scene)
 await wait_seconds(.4)
 assert_false(RanchMusic.voice.playing,"pending menu tween cancelled")
 assert_eq(RanchMusic.context,"")
 assert_true(scene.selector.visible)
 scene.selector.hide();scene.countdown=2.
 await wait_seconds(.35)
 assert_false(RanchMusic.voice.playing,"silent while 3-2-1")
 assert_false(scene.running)
 scene.countdown=.02
 await wait_seconds(.35)
 assert_true(scene.running);assert_eq(RanchMusic.context,"race")
 assert_true(RanchMusic.voice.playing)
 # Retry, including same race context, must not retain the old voice.
 scene.free();scene=null
 RaceCourse190.start_selected=true
 scene=load("res://src/Presentation/race190.tscn").instantiate();add_child(scene)
 await wait_seconds(.3)
 assert_false(RanchMusic.voice.playing,"retry clears previous race music")
 assert_gt(scene.countdown,0.)
func test_joust_music_starts_during_preparation_and_continues_at_go():
 scene=load("res://src/Presentation/joust196.tscn").instantiate();add_child(scene)
 await wait_seconds(.6)
 assert_gt(scene.countdown,0.);assert_false(scene.running)
 assert_eq(RanchMusic.context,"duel");assert_true(RanchMusic.voice.playing)
 var before:float=RanchMusic.voice.get_playback_position()
 scene.countdown=.02
 await wait_seconds(.25)
 assert_true(scene.running)
 assert_gt(RanchMusic.voice.get_playback_position(),before,"no restart on GO")
func test_stop_does_not_break_mute_or_single_voice():
 RanchMusic.play_context("menu");RanchMusic.stop_context()
 RanchMusic.set_enabled(false);await wait_seconds(.3)
 assert_false(RanchMusic.voice.playing)
 RanchMusic.play_context("race");await wait_seconds(.3)
 assert_eq(RanchMusic.context,"race");assert_eq(RanchMusic.voice.volume_db,-80.)
 assert_eq(RanchMusic.get_child_count(),1)
