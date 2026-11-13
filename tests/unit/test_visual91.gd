extends GutTest
func test_held_hand_is_exactly_flight_hand_even_with_flip_and_displacement():
 SaveData.horse_collection.seed_trial()
 var rider=load("res://src/Presentation/world_player.gd").new();add_child_autofree(rider);rider.set_physics_process(false);rider.position=Vector2(300,400)
 for flip in [false,true]:
  for y in [0,-25]:
   rider._sprite_swap._sprite.flip_h=flip;rider._sprite_swap._sprite.position.y=y
   assert_eq(LassoRopeStyle.rider_hand(rider),rider.lasso.flight_origin_global())
   assert_lt(LassoRopeStyle.rider_hand(rider).y,rider.global_position.y-60)
func test_cached_ground_uv_has_no_chunk_discontinuity():
 for seed in [752026,1,42]:
  for x in [-2,-1,0,1,2]:
   var edge=Vector2(x*WorldMap.CHUNK_SIZE,40)
   var left=WorldGrassTexture.uv_at(seed,edge-Vector2(.01,0))
   var right=WorldGrassTexture.uv_at(seed,edge+Vector2(.01,0))
   assert_almost_eq(right.x-left.x,.02/WorldGrassTexture.PERIOD,.00001)
 assert_eq(WorldGrassTexture.CACHE.get_size(),Vector2(1024,1024))
func test_quest_button_is_visible_same_footprint_and_interactive():
 var b=Button.new();b.position=Vector2(16,56);b.size=Vector2(180,42);add_child_autofree(b);QuestButtonStyle.apply(b)
 assert_eq(b.position,Vector2(16,56));assert_eq(b.size,Vector2(180,42));assert_false(b.disabled)
 assert_eq(b.get_theme_stylebox("normal").bg_color,Color("efb950"))

func test_contextual180_is_readable_tall_and_uses_shared_states_without_rewiring():
 var b:=Button.new();b.text="Hablar con granjero";b.position=Vector2(475,566);var calls:Array=[];b.pressed.connect(func():calls.append(true));add_child_autofree(b)
 QuestButtonStyle.contextual180(b)
 assert_eq(b.position,Vector2(475,566));assert_eq(b.custom_minimum_size,Vector2(330,56));assert_gte(b.size.y,56.)
 assert_eq(b.get_theme_font_size("font_size"),22);assert_eq(b.get_theme_color("font_color"),Color("342313"));assert_false(b.disabled)
 for state in ["normal","hover","pressed","focus"]:assert_true(b.has_theme_stylebox_override(state))
 assert_ne(b.get_theme_stylebox("pressed").bg_color,b.get_theme_stylebox("normal").bg_color)
 b.pressed.emit();assert_eq(calls,[true]);assert_eq(b.text,"Hablar con granjero")
