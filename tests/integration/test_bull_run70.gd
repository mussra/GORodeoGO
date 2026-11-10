extends GutTest
func before_each()->void:
 get_tree().paused=false;Engine.time_scale=1.0;GameState.selected_level=1;SaveData.dual_lasso_intro_shown=true
func test_real_bull_physics_uses_pixellab_frames_and_advances_while_running()->void:
 var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child_autofree(level)
 await wait_process_frames(4)
 var bull=level.all_bulls[0];bull.begin_active();bull._stations=[]
 bull.global_position=Vector2(900,330);bull._player.global_position=Vector2(450,330)
 var start:Vector2=bull.global_position
 await wait_seconds(.25)
 assert_gt(bull.global_position.distance_to(start),10.0)
 assert_true(bull._sprite_swap._sprite.animation.begins_with("flee_"))
 assert_true(bull._sprite_swap._frames.get_frame_texture(bull._sprite_swap._sprite.animation,0).resource_path.contains("pixellab/bull"))
 var phase:float=float(bull._sprite_swap._sprite.frame)+bull._sprite_swap._sprite.frame_progress
 await wait_seconds(.12)
 var later:float=float(bull._sprite_swap._sprite.frame)+bull._sprite_swap._sprite.frame_progress
 assert_ne(phase,later,"Los fotogramas avanzan mientras corre")
 assert_gt(bull._sprite_swap._sprite.speed_scale,.7)
 level.queue_free();await wait_process_frames(3)

func test_drink_approach_runs_until_stationary()->void:
 var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child_autofree(level)
 await wait_process_frames(4)
 var bull=level.all_bulls[0];bull.begin_active();bull._stations=[];bull.set_physics_process(false)
 bull.global_position=Vector2(700,330);bull._player.global_position=Vector2(300,330)
 assert_true(bull._distraction.try_start(true,true,"water"))
 bull._distraction_target=bull.global_position+Vector2(60,0)
 bull._physics_process(.05)
 assert_true(bull._sprite_swap._sprite.animation.begins_with("flee_"))
 bull.global_position=bull._distraction_target;bull._physics_process(.05)
 assert_eq(bull._sprite_swap._sprite.animation,"drinking")
 level.queue_free();await wait_process_frames(3)
