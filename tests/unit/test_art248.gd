extends GutTest
func test_wall_sampler_is_mirrored_and_world_coordinates_share_phase_at_chunk_edges():
 assert_eq(TownPaint215.REPEAT248,CanvasItem.TEXTURE_REPEAT_MIRROR)
 for p in [Vector2(1024,300),Vector2(-1024,-340),Vector2(0,128),Vector2(3000,2048)]:
  assert_eq(TownPaint215.uv248(p),p/128.)
 var view=load('res://src/Presentation/town_arrival_view244.gd').new()
 view.plan={'bounds':Rect2(0,0,200,200)};add_child_autofree(view)
 assert_eq(view.walls.texture_repeat,TownPaint215.REPEAT248)
func test_names_have_no_coordinates_but_do_not_change_identity_or_saved_names():
 var old:int=SaveData.world_generator_version;SaveData.world_generator_version=6
 for id in TownNetwork234.base_nodes(752026):
  var original:String=TownIdentity215.title({'seed':752026},id)
  var displayed:String=TownIdentity215.display_name248({'seed':752026},id)
  assert_false(displayed.contains(' · '));assert_false(displayed.is_empty());assert_true(original.begins_with(displayed))
 SaveData.world_generator_version=old
func test_directions_and_simple_minutes():
 for pair in [[Vector2(10,0),'este'],[Vector2(-10,0),'oeste'],[Vector2(0,-10),'norte'],[Vector2(0,10),'sur'],[Vector2(10,-10),'noreste'],[Vector2(-10,10),'suroeste']]:
  assert_eq(TownMessages247.direction248(Vector2.ZERO,pair[0]),pair[1])
 assert_eq(TravelEstimate237.minutes248(0.),'Tardarás aproximadamente 1 minuto con ese caballo.')
 assert_eq(TravelEstimate237.minutes248(125.),'Tardarás aproximadamente 2 minutos con ese caballo.')
func test_thumbnail_uses_real_plan_and_bounded_raster_cache():
 var old:int=SaveData.world_generator_version;SaveData.world_generator_version=6
 var preview:=TownThumbnail248.new();preview.seed_=752026;preview.town='home';add_child_autofree(preview)
 assert_eq(preview.plan248,TownEnclosures227.plans(752026).home)
 assert_eq(preview.look248,TownIdentity215.look(SaveData.world_cousins140,'home'))
 assert_eq(preview.raster248.size,TownThumbnail248.EXTENT)
 assert_eq(preview.raster248.render_target_update_mode,SubViewport.UPDATE_ONCE)
 assert_eq(TownThumbnail248.LIMIT,24);SaveData.world_generator_version=old
