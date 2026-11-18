extends GutTest
var parade:LoadingParade
func before_each():
 parade=LoadingParade.new();add_child(parade)
 while not parade.prepared:await wait_process_frames(1)
 parade.set_process(false)
func after_each():parade.free();await wait_process_frames(2)
func test_rider_and_wild_horse_share_body_scale_without_adding_a_rider():
 var horse=parade.actors.filter(func(a):return a.kind=="horse")[0].sprite
 assert_eq(parade.rider.scale,horse.scale);assert_eq(horse.sprite_frames.get_frame_texture("side",0).get_size(),Vector2(96,96))
 assert_eq(horse.get_child_count(),0,"Wild horse receives no owner/rider node")
func test_farmer_uses_visible_adult_height_not_the_full_png_canvas():
 var farmer=parade.frontier_people267[0]
 assert_almost_eq(NpcScale214.visible_bounds(farmer.texture).size.y*farmer.scale.y,LoadingParade.DISTANT_HEIGHT267,.01)
func test_all_actors_share_ground_line_and_rider_uses_equipped_appearance():
 var selected:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
 assert_eq(parade.rider.get_meta("traits228"),selected.traits)
 for actor in parade.actors:
  parade.age=actor.delay+1.;parade._process(0.)
  assert_eq(actor.sprite.position.y,LoadingParade.FLOOR228);assert_eq(parade.rider.position.y,LoadingParade.FLOOR228)

func test_frontier_people_are_distant_distinct_and_do_not_replace_animals():
 assert_eq(parade.frontier_people267.size(),6)
 assert_eq(parade.actors.size(),3)
 var roles:Array=[]
 parade._process(.1)
 for figure in parade.frontier_people267:
  assert_false(roles.has(figure.get_meta("frontier_role267")));roles.append(figure.get_meta("frontier_role267"))
  assert_lte(figure.position.y,421.);assert_lt(figure.position.y,LoadingParade.FLOOR228)
  assert_lt(figure.z_index,parade.rider.z_index)
  assert_almost_eq(NpcScale214.visible_bounds(figure.texture).size.y*figure.scale.y,46.,.01)
 assert_true(roles.has("Granjero"));assert_true(roles.has("Alma"));assert_true(roles.has("Juanito"))
