extends GutTest
var world:CountryPreview146
func after_each():
 if is_instance_valid(world):world.free()
 await get_tree().process_frame
func test_solid_polygon_matches_supplied_lower_silhouette_and_not_whole_canopy():
 var data:=CountryRoute146.plan(752026);assert_eq(data.tree_art.size,Vector2(2800,2394));assert_eq(data.tree_solid.size(),58);assert_true(CountryRoute146.blocked(data,data.roots));assert_true(CountryRoute146.path_clear(data,data.approach));assert_true(CountryRoute146.path_clear(data,data.upstream))
 var outline:PackedVector2Array=MotherTree155.OUTLINE
 for p in outline:assert_gte(p.y,650.)
func test_actual_root_shape_blocks_rider_and_saved_root_position_has_safe_recovery():
 world=CountryPreview146.new();add_child(world);world.player.set_physics_process(false);await get_tree().physics_frame
 var solid:StaticBody2D=world.get_node("MotherTreeGround155");assert_eq((solid.get_child(0) as CollisionPolygon2D).polygon,world.data.tree_solid)
 var start:Vector2=world.data.roots+Vector2(1500,0);world.player.position=start;var collision:=world.player.move_and_collide(world.data.roots-start);assert_not_null(collision)
 var inside:Vector2=world.data.tree_art.position+world.data.tree_art.size*Vector2(.50,.82);world.player.position=inside;assert_true(CountryRoute146.blocked(world.data,inside));var recovery:=world.landing155(inside);assert_true(recovery.is_finite());assert_false(CountryRoute146.blocked(world.data,recovery));assert_gt(recovery.distance_to(inside),96.)
func test_tree_is_overhead_and_map_shows_it_only_after_it_is_discovered():
 world=CountryPreview146.new();add_child(world);world.player.set_physics_process(false);assert_gt(world.tree_sprite155.z_index,world.player.z_index);world.show_map();var view:CountryMap148=world.modal;await get_tree().process_frame;assert_false(view.tree_visible155);world.close_modal();await get_tree().process_frame
 world.player.position=world.data.sites.tree;world._process(0.);world.show_map();view=world.modal;await get_tree().process_frame;assert_true(view.tree_visible155)
 var selected_:Array=[];view.selected.connect(func(id):selected_.append(id));view.select_at(view.canvas.get_global_transform_with_canvas()*view.point(world.data.roots));assert_eq(selected_,["tree"])
