extends GutTest
func _world()->Node2D:
 var w=Node2D.new();w.y_sort_enabled=true;add_child_autofree(w);return w
func test_continuous_fence_stops_untrained_rider_and_pigs():
 SaveData.horse_collection.seed_trial()
 var w=_world();WorldFence.segment(w,Vector2(-120,0),Vector2(120,0))
 var actor=load("res://src/Presentation/world_player.gd").new();w.add_child(actor);actor.set_physics_process(false);actor.position=Vector2(0,70)
 await wait_physics_frames(2)
 assert_true(actor.test_move(actor.global_transform,Vector2(0,-140)),"Middle between posts must collide")
 assert_false(actor.request_jump(Vector2.UP),"Untrained horse cannot jump")
 var pig=load("res://src/Presentation/wild_pig.gd").new();pig.setup({"pos":Vector2(0,10)});w.add_child(pig)
 pig.flee_from(Vector2(0,40),.3,170)
 assert_gt(pig.position.y,0,"Pig cannot walk through rails")
func test_trained_rider_uses_shared_jump_and_preserves_world_scale():
 SaveData.horse_collection.seed_trial()
 var w=_world();WorldFence.segment(w,Vector2(-120,0),Vector2(120,0))
 var actor=load("res://src/Presentation/world_player.gd").new();w.add_child(actor);actor.set_physics_process(false);actor.position=Vector2(0,70);actor.can_jump=true
 await wait_physics_frames(2)
 var scale=actor._sprite_swap._sprite.scale
 var sprite=actor._sprite_swap._sprite
 assert_almost_eq(sprite.position.y+(44+sprite.offset.y)*sprite.scale.y,0.0,.01,"Hooves and y-sort/collision share ground pivot")
 assert_true(actor.request_jump(Vector2.UP))
 assert_eq(actor.collision_mask & HorseJump.FENCE_LAYER,0)
 for i in 45:HorseJumpMotion.process(actor,1.0/60.0)
 assert_lt(actor.position.y,-80)
 assert_eq(actor.collision_mask & HorseJump.FENCE_LAYER,HorseJump.FENCE_LAYER)
 assert_eq(actor._sprite_swap._sprite.scale,scale)
func test_jump_rejects_solid_landing_and_goat_has_visible_arc():
 SaveData.horse_collection.seed_trial()
 var w=_world();WorldFence.segment(w,Vector2(-120,0),Vector2(120,0));WorldPhysics.add_box(w,Rect2(-30,-130,60,40))
 var actor=load("res://src/Presentation/world_player.gd").new();w.add_child(actor);actor.set_physics_process(false);actor.position=Vector2(0,70);actor.can_jump=true
 var goat=load("res://src/Presentation/wild_goat.gd").new();goat.setup({"pos":Vector2(80,12)});w.add_child(goat)
 await wait_physics_frames(2)
 assert_false(actor.request_jump(Vector2.UP))
 goat.move_from_or_towards(Vector2(80,40),.1,false)
 assert_gt(goat._fence_jump,0)
 goat._process(.1)
 assert_lt(goat.goat_art.position.y,0)
func test_quest_fold_and_missing_skills_hidden_in_actual_world():
 SaveData.trial_session_active=true;SaveData.horse_collection.seed_trial();SaveData.world_quests={};SaveData.world_position=Vector2.ZERO
 var selected=SaveData.horse_collection.find(SaveData.horse_collection.selected);selected.can_dodge=false;selected.can_jump=false
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child_autofree(world)
 while world._loading_world:await wait_process_frames(1)
 assert_false(world._quest_panel.visible)
 world._quest_toggle.pressed.emit();assert_true(world._quest_panel.visible)
 world._quest_toggle.pressed.emit();assert_false(world._quest_panel.visible)
 assert_false(world._gauges.dodge.visible)
 assert_false(world._gauges.jump.visible)
 assert_true(world._gauges.stamina.visible)

func test_old_save_inside_new_fence_recovers_locally():
 SaveData.horse_collection.seed_trial()
 var w=_world();WorldFence.segment(w,Vector2(-120,0),Vector2(120,0))
 var actor=load("res://src/Presentation/world_player.gd").new();w.add_child(actor);actor.set_physics_process(false);actor.position=Vector2.ZERO
 await wait_physics_frames(2)
 assert_true(WorldFence.clear_spawn(actor))
 assert_gt(actor.position.length(),0.0)
 assert_lte(actor.position.length(),48.01)
 assert_false(actor.test_move(actor.global_transform,Vector2.ZERO))
