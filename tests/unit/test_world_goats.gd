extends GutTest
func test_reverses_when_roped():
 var free=WorldGoats.tick(WorldGoats.new_state(),100,false,.1)
 var held=WorldGoats.tick(free,100,true,.1)
 assert_true(free.flee);assert_false(held.flee);assert_eq(held.progress,0.0);assert_gt(held.run,free.run)
func test_contact_wins_over_capture():
 var st=WorldGoats.new_state();st.progress=.99
 st=WorldGoats.tick(st,40,true,1)
 assert_true(st.break_rope);assert_true(st.contact);assert_eq(st.progress,0.0)
func test_distance_and_survival():
 var st=WorldGoats.tick(WorldGoats.new_state(),241,true,1)
 assert_true(st.break_rope);assert_false(st.contact)
 st=WorldGoats.new_state();st.tired=true
 st=WorldGoats.tick(st,100,true,1)
 assert_eq(st.progress,1.0)
func test_pig_distance_break_even_tired():
 var st=WorldPigs.new_chase_state();st.tired=true;st.progress=.9
 st=WorldPigs.chase_tick(st,241,100,true,1)
 assert_true(st.break_rope);assert_eq(st.progress,0.0)

func test_nominal_nine_frames_and_stable_pivot():

 var goat=load("res://src/Presentation/wild_goat.gd").new()
 goat.setup({"pos":Vector2.ZERO});add_child_autofree(goat)
 for view in ["run","run_down","run_up"]:
  assert_eq(goat.goat_art.sprite_frames.get_frame_count(view),9)
  assert_eq(goat.goat_art.sprite_frames.get_animation_speed(view),9.0)
  assert_true(goat.goat_art.sprite_frames.get_frame_texture(view,0).resource_path.contains("pixellab/goat"))
 assert_eq(goat.goat_art.offset,Vector2(-80,-144))
 assert_eq(goat.goat_art.scale,Vector2.ONE*.40)

func test_roped_goat_moves_towards_rider_not_away():
 var goat=load("res://src/Presentation/wild_goat.gd").new();goat.setup({"pos":Vector2(200,200)});add_child_autofree(goat)
 var rider=Vector2(50,200);var before:float=goat.position.distance_to(rider)
 goat.move_from_or_towards(rider,.1,true)
 assert_lt(goat.position.distance_to(rider),before)
 var after:float=goat.position.distance_to(rider)
 goat.move_from_or_towards(rider,.1,false)
 assert_gt(goat.position.distance_to(rider),after)
