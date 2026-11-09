extends GutTest
func test_pig_roped_ignores_home_leash_and_vertical_animation():
 var pig=load("res://src/Presentation/wild_pig.gd").new();pig.setup({"pos":Vector2.ZERO});add_child_autofree(pig)
 pig.position=Vector2(0,WorldPigs.FLEE_LEASH+10);pig.roped=true
 pig.flee_from(Vector2.ZERO,1.0,225)
 assert_gt(pig.position.y,WorldPigs.FLEE_LEASH+200)
 pig.state.flee=true;await wait_process_frames(2)
 assert_eq(pig._art.animation,"run_down")
 assert_eq(pig._art.sprite_frames.get_frame_count("run_down"),12)
func test_goat_contact_releases_real_shared_lasso_session():
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child_autofree(world)
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var goat=world._prototype_goats.get_child(0)
 goat.position=world.player.position+Vector2(140,0)
 world._on_lasso_prey_captured(goat)
 world._tick_goats(.1)
 assert_true(goat.roped);assert_eq(world._lasso_state,"hold")
 assert_lt(goat.position.distance_to(world.player.position),140)
 goat.position=world.player.position+Vector2(40,0);world._tick_goats(.1)
 assert_false(goat.roped);assert_eq(world._lasso_state,"")
 assert_gt(world.player._stun_time_remaining,0)
func test_goat_survival_captures_once_without_rewards_or_persisting():
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child_autofree(world)
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var goat=world._prototype_goats.get_child(0);goat.position=world.player.position+Vector2(140,0)
 var points:int=SaveData.equipment_points;var pens:int=SaveData.world_pigs.size()
 world._on_lasso_prey_captured(goat);world._tick_goats(WorldGoats.SURVIVE_SECONDS)
 assert_true(goat.is_queued_for_deletion());assert_eq(world._lasso_state,"")
 assert_eq(SaveData.equipment_points,points);assert_eq(SaveData.world_pigs.size(),pens)
